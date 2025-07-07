################################################################################
# Helm-release: kube-prometheus-stack
# CHART: https://github.com/prometheus-community/helm-charts/blob/main/charts/kube-prometheus-stack
# VALUES: https://raw.githubusercontent.com/prometheus-community/helm-charts/main/charts/kube-prometheus-stack/values.yaml
# NOTE! The value specification follows the order of the values.yaml to be more easy to follow the params setup and add new ones
################################################################################

# non string or boolean values cannot be set as value in helm
# https://github.com/hashicorp/terraform-provider-helm/issues/669
# all the map variables need to apply this little trick
locals {
  # general variables
  global_helm_vars = {
    #commonLabels = local.resource_labels
    prometheusOperator = {
      nodeSelector = var.stack_monitoring_node_selector
    }
  }

    prometheus_helm_vars = {
    customRules = var.prometheus_change_default_rules
    additionalPrometheusRulesMap = merge(var.prometheus_additional_rules, local.default_watchdog_rule_configured)
    prometheus = {
      nodeSelector = var.stack_monitoring_node_selector
      prometheusSpec = {
        additionalScrapeConfigs = concat(var.prometheus_additional_scrape, var.prometheus_blackbox_scrape)
        alertingEndpoints = var.alertmanager_use_external
        externalLabels = local.alert_labels
        scrapeInterval = "30s"
        evaluationInterval: "30s"
        storageSpec = var.enable_prometheus_persistence ? {
          volumeClaimTemplate = {
            spec = {
              resources = {
                requests = {
                  storage = "${var.prometheus_pvc_size}Gi"
                }
              }
              accessModes = ["ReadWriteOnce"]
            }
          }
        } : {}
      }
    }
  }

  # alertmanager
  alertmanager_helm_vars = {
    nodeSelector = var.stack_monitoring_node_selector
    alertmanager = {
      config = {
        route = var.alertmanager_config_route
        inhibit_rules = var.alertmanager_config_inhibit_rules
        time_intervals = var.alertmanager_time_intervals
      }
      templateFiles = local.default_alertmanager_template
      alertmanagerSpec = {
        storage = var.enable_alertmanager_persistence ? {
          volumeClaimTemplate = {
            spec = {
              resources = {
                requests = {
                  storage = "${var.alertmanager_pvc_size}Gi"
                }
              }
              accessModes = ["ReadWriteOnce"]
            }
          }
        } : {}
      }
    }
  }
  # with credential gets always interpreted as string
  alertmanager_config_receivers = <<EOL
---
alertmanager:
  config:
    receivers:
      ${join("\n      ", split("\n", var.alertmanager_config_receivers))}
EOL

  grafana_helm_vars = {
    grafana = {
      nodeSelector = var.stack_monitoring_node_selector
      dashboards = {
        default = var.grafana_dashboard_import
      }
      "grafana.ini" = {
        feature_toggles = {
          enable = var.grafana_feature_toggles
        }
        server = {
          root_url = "https://${var.grafana_domain_name}"
        }
      }
    }
  }

}

resource "helm_release" "kube_prometheus_stack" {
  name       = "kube-prometheus-stack"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  version    = "72.0.0"
  namespace  = var.namespace

  values = [
    file("${path.module}/values.yaml"),
    # general vars
    yamlencode(local.global_helm_vars),

    # alertmanager
    yamlencode(local.alertmanager_helm_vars),
    local.alertmanager_config_receivers,

    # grafana
    yamlencode(local.grafana_helm_vars),
    local.dashboard_default_provider,

    # prometheus
    yamlencode(local.prometheus_helm_vars)

  ]

  dynamic "set" {
    for_each = toset(var.disable_component_scraping)
    content {
      name  = "${set.key}.enabled"
      value = false
    }
  }

  # ALERTMANAGER
  set {
    name  = "alertmanager.enabled"
    value = var.alertmanager_install
  }

  set {
    name  = "alertmanager.ingress.enabled"
    value = var.alertmanager_install
  }

  set {
    name  = "alertmanager.ingress.hosts[0]"
    value = var.alertmanager_domain_name
  }

  set {
    name  = "alertmanager.ingress.annotations.nginx\\.ingress\\.kubernetes\\.io/auth-type"
    value = "basic"
  }
  set {
    name  = "alertmanager.ingress.annotations.nginx\\.ingress\\.kubernetes\\.io/auth-secret"
    value = "alertmanager-basic-auth-${var.project}-${var.env}"
  }
  set {
    name  = "alertmanager.ingress.annotations.nginx\\.ingress\\.kubernetes\\.io/auth-secret-type"
    value = "auth-map"
  }

  # Prometheus data retention
  set {
    name  = "alertmanager.alertmanagerSpec.retention"
    value = var.enable_alertmanager_persistence ? var.alertmanager_data_retention : "120h"
  }
  # GRAFANA
  set {
    name  = "grafana.enabled"
    value = var.grafana_install
  }

  set {
    name  = "grafana.defaultDashboardsEnabled"
    value = var.enable_default_grafana_dashboards
  }

  set {
    name  = "grafana.defaultDashboardsTimezone"
    value = var.grafana_default_timezone
  }

  set {
    name  = "grafana.adminPassword"
    value = var.grafana_install ? random_password.grafana_basic_auth_password[0].result : ""
  }

  set {
    name  = "grafana.adminUser"
    value = local.username
  }

  set {
    name  = "grafana.ingress.enabled"
    value = var.grafana_install
  }

  set {
    name  = "grafana.ingress.hosts[0]"
    value = var.grafana_domain_name
  }

  # Grafana data persistency
  set {
    name  = "grafana.persistence.enabled"
    value = var.enable_grafana_persistence
  }
  set {
    name  = "grafana.persistence.type"
    value = "pvc"
  }
  set {
    name  = "grafana.persistence.accessModes[0]"
    value = "ReadWriteOnce"
  }
  set {
    name  = "grafana.persistence.size"
    value = "${var.grafana_pvc_size}Gi"
  }
  set {
    name  = "grafana.operator.folder"
    value = "Kubernetes"
  }

  # PROMETHEUS
  set {
    name  = "prometheus.enabled"
    value = var.prometheus_install
  }

  set {
    name  = "defaultRules.appNamespacesTarget"
    value = var.prometheus_rules_namespaces
  }

  # Disable monitoring rule
  # https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack/templates/prometheus/rules-1.14
  dynamic "set" {
    for_each = toset(local.default_rules_disabled)
    content {
      name  = "defaultRules.rules.${set.key}"
      value = false
    }
  }

  # Disable specific Alert from rules
  # Usefull if alert not used or overrided
  dynamic "set" {
    for_each = length(local.default_alerts_disabled) > 0 ? toset(local.default_alerts_disabled) : toset([])
    content {
      name  = "defaultRules.disabled.${set.key}"
      value = true
    }
  }

  set {
    name  = "prometheus.ingress.enabled"
    value = var.prometheus_install
  }

  set {
    name  = "prometheus.ingress.hosts[0]"
    value = var.prometheus_domain_name
  }

  set {
    name  = "prometheus.ingress.annotations.nginx\\.ingress\\.kubernetes\\.io/auth-type"
    value = "basic"
  }
  set {
    name  = "prometheus.ingress.annotations.nginx\\.ingress\\.kubernetes\\.io/auth-secret"
    value = "prometheus-basic-auth-${var.project}-${var.env}"
  }
  set {
    name  = "prometheus.ingress.annotations.nginx\\.ingress\\.kubernetes\\.io/auth-secret-type"
    value = "auth-map"
  }

  set {
    name  = "prometheus.prometheusSpec.serviceMonitorSelectorNilUsesHelmValues"
    value = "false"
  }

  # Prometheus data retention
  set {
    name  = "prometheus.prometheusSpec.retention"
    value = var.enable_prometheus_persistence ? var.prometheus_data_retention : "10d"
  }

  # kube-state-metrics
  # In order to get annotations on kube_namespace_annotations metrics, we need to allow it on kube-state-metrics
  # https://github.com/kubernetes/kube-state-metrics/issues/1582
  set {
    name  = "kube-state-metrics.metricAnnotationsAllowList[0]"
    value = "namespaces=[*]"
  }

}
