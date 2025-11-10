################################################################################
# Helm-release: kube-prometheus-stack
# CHART: https://github.com/prometheus-community/helm-charts/blob/main/charts/kube-prometheus-stack
# VALUES: https://raw.githubusercontent.com/prometheus-community/helm-charts/main/charts/kube-prometheus-stack/values.yaml
# UPGRADE: https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack#upgrading-an-existing-release-to-a-new-major-version
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
    customRules                  = var.prometheus_change_default_rules
    additionalPrometheusRulesMap = merge(var.prometheus_additional_rules, local.default_watchdog_rule_configured)
    prometheus = {
      nodeSelector = var.stack_monitoring_node_selector
      prometheusSpec = {
        additionalScrapeConfigs = concat(var.prometheus_additional_scrape, var.prometheus_blackbox_scrape)
        alertingEndpoints       = var.alertmanager_use_external
        externalLabels          = local.alert_labels
        scrapeInterval          = "30s"
        evaluationInterval : "30s"
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
        route          = var.alertmanager_config_route
        inhibit_rules  = var.alertmanager_config_inhibit_rules
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

  # https://github.com/grafana/helm-charts/blob/main/charts/grafana/values.yaml
  grafana_helm_vars = {
    grafana = {
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
      alerting = {
        # rules template can contains {{}}. This need to be escaped to avoid helm rendering it
        "rules.yaml" = yamldecode(replace(replace(replace(yamlencode(var.grafana_alert_rules), "{{", "@@Start@@"), "}}", "{{`}}`}}"), "@@Start@@", "{{`{{`}}"))
      }
    }
  }

  # with credential gets always interpreted as string
  grafana_additional_datasources = yamlencode({
    grafana = {
      additionalDataSources = var.grafana_additional_datasources
    }
  })


  global_values = yamlencode(provider::deepmerge::mergo(
    {
      crds = {
        upgradeJob = {
          enabled = true
        }
      }

      # ALERTMANAGER
      alertmanager = {
        enabled = var.alertmanager_install
        ingress = {
          enabled = var.alertmanager_install
          hosts = [
            var.alertmanager_domain_name
          ]
          annotations = {
            "nginx.ingress.kubernetes.io/auth-type"        = "basic"
            "nginx.ingress.kubernetes.io/auth-secret"      = kubernetes_secret.alertmanager_basic_auth[0].metadata[0].name
            "nginx.ingress.kubernetes.io/auth-secret-type" = "auth-map"
          }
        }
        # Prometheus data retention
        alertmanagerSpec = {
          retention = var.enable_alertmanager_persistence ? var.alertmanager_data_retention : "120h"
        }


      }

      # GRAFANA
      grafana = {
        enabled                   = var.grafana_install
        defaultDashboardsEnabled  = var.enable_default_grafana_dashboards
        defaultDashboardsTimezone = var.grafana_default_timezone
        adminPassword             = var.grafana_install ? random_password.grafana_basic_auth_password[0].result : ""
        adminUser                 = local.username

        nodeSelector = var.stack_monitoring_node_selector

        ingress = {
          enabled = var.grafana_install
          hosts = [
            var.grafana_domain_name
          ]
        }

        sidecar = {
          datasources = {
            alertmanager = {
              handleGrafanaManagedAlerts = true
            }
          }
        }

        # Grafana data persistency
        persistence = {
          enabled = var.enable_grafana_persistence
          type    = "pvc"
          accessModes = [
            "ReadWriteOnce"
          ]
          size = "${var.grafana_pvc_size}Gi"
        }

        operator = {
          folder = "Kubernetes"
        }
      }

      # PROMETHEUS
      prometheus = {
        enabled = var.prometheus_install

        ingress = {
          enabled = var.prometheus_install
          hosts = [
            var.prometheus_domain_name
          ]
          annotations = {
            "nginx.ingress.kubernetes.io/auth-type"        = "basic"
            "nginx.ingress.kubernetes.io/auth-secret"      = kubernetes_secret.prometheus_basic_auth[0].metadata[0].name
            "nginx.ingress.kubernetes.io/auth-secret-type" = "auth-map"
          }
        }

        prometheusSpec = {
          serviceMonitorSelectorNilUsesHelmValues = false
          # Prometheus data retention
          retention = var.enable_prometheus_persistence ? var.prometheus_data_retention : "10d"
        }


      }

      defaultRules = {
        appNamespacesTarget = var.prometheus_rules_namespaces
      }


      # kube-state-metrics
      # In order to get annotations on kube_namespace_annotations metrics, we need to allow it on kube-state-metrics
      # https://github.com/kubernetes/kube-state-metrics/issues/1582

      kube-state-metrics = {
        metricAnnotationsAllowList = [
          "namespaces=[*]"
        ]
      }
    },

    {
      for k, v in toset(var.disable_component_scraping) :
      k => {
        enabled = false
      }
    },
    # Disable monitoring rule
    # https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack/templates/prometheus/rules-1.14
    {
      defaultRules = {
        rules = {
          for k, v in toset(local.default_rules_disabled) :
          k => false
        }
      }
    },
    # Disable specific Alert from rules
    # Usefull if alert not used or overrided
    try(length(local.default_alerts_disabled) > 0, false) ?
    {
      defaultRules = {
        disabled = {
          for k, v in toset(local.default_alerts_disabled) :
          k => false
        }
      }
    } : null,

  ))
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
    yamlencode(local.prometheus_helm_vars),
    local.grafana_additional_datasources,

    local.global_values
  ]
}
