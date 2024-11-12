################################################################################
# Helm-release: kube-prometheus-stack
# CHART: https://github.com/prometheus-community/helm-charts/blob/main/charts/kube-prometheus-stack
# VALUES: https://raw.githubusercontent.com/prometheus-community/helm-charts/main/charts/kube-prometheus-stack/values.yaml
# NOTE! The value specification follows the order of the values.yaml to be more easy to follow the params setup and add new ones
# todo: backup of configs, extra dashboards grafana
################################################################################

# non string or boolean values cannot be set as value in helm
# https://github.com/hashicorp/terraform-provider-helm/issues/669
# all the map variables need to apply this little trick
locals {

# general variables
  commonLabels= <<EOL
---
commonLabels:
    ${yamlencode(local.common_labels)}
EOL

  prometheus_operator_node_selector= <<EOL
---
prometheusOperator:
  nodeSelector:
    ${yamlencode(var.stack_monitoring_node_selector)}
EOL

# alertmanager
  alertmanager_customRules= <<EOL
---
customRules:
    ${yamlencode(var.alertmanager_customRules)}
EOL

  alertmanager_additional_rules= <<EOL
---
additionalPrometheusRulesMap:
    ${yamlencode(var.alertmanager_additional_rules)}
EOL

  alertmanager_config= <<EOL
---
alertmanager:
  config:
    ${yamlencode(var.alertmanager_config)}
EOL

  alertmanager_node_selector= <<EOL
---
alertmanager:
  nodeSelector:
    ${yamlencode(var.stack_monitoring_node_selector)}
EOL

# grafana
  grafana_node_selector= <<EOL
---
grafana:
  nodeSelector:
    ${yamlencode(var.stack_monitoring_node_selector)}
EOL

# prometheus
  prometheus_node_selector= <<EOL
---
prometheus:
  nodeSelector:
    ${yamlencode(var.stack_monitoring_node_selector)}
EOL

  prometheus_additional_scrape= <<EOL
---
prometheus:
  prometheusSpec:
    additionalScrapeConfigs:
      ${yamlencode(var.prometheus_additional_scrape)}
EOL

  alertmanager_use_external= <<EOL
---
prometheus:
  prometheusSpec:
    alertingEndpoints:
      ${yamlencode(var.alertmanager_use_external)}
EOL

# thanos
  thanos_node_selector= <<EOL
---
thanos:
  nodeSelector:
    ${yamlencode(var.stack_monitoring_node_selector)}
EOL

}
resource "helm_release" "kube_prometheus_stack" {
  name       = "kube-prometheus-stack"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  version    = var.kube_prometheus_helm_version
  namespace  = var.namespace

  values = [
    file("${path.module}/values.yaml"),
    # general vars
    local.commonLabels,
    local.prometheus_operator_node_selector,

    # alertmanager
    local.alertmanager_customRules,
    local.alertmanager_additional_rules,
    local.alertmanager_config,
    local.alertmanager_node_selector,

    # grafana
    local.grafana_node_selector,

    # prometheus
    local.prometheus_node_selector,
    local.prometheus_additional_scrape,
    local.alertmanager_use_external,

    #thanos
    local.thanos_node_selector,

  ]
  # GENERAL VARS
  #set {
  #  name  = "commonLabels"
  #  value = local.common_labels
  #}

  dynamic "set" {
    for_each = toset(var.disable_component_scraping)
    content {
      name  = "${set.key}.enabled"
      value = false
    }
  }

  #set {
  #  name  = "prometheusOperator.nodeSelector"
  #  value = var.stack_monitoring_node_selector
  #}

  # ALERTMANAGER
  #set {
  #  name  = "customRules"
  #  value = var.alertmanager_customRules
  #}
  #set {
  #  name  = "additionalPrometheusRulesMap"
  #  value = «var.alertmanager_additional_rules
  #}

  set {
    name  = "alertmanager.enabled"
    value = var.alertmanager_install
  }

  #set {
  #  name  = "alertmanager.config"
  #  value = jsonencode(var.alertmanager_config)
  #}

  set {
    name  = "alertmanager.ingress.enabled"
    value = var.alertmanager_install
  }

  set {
    name  = "alertmanager.ingress.hosts"
    value = var.alertmanager_domain_name
  }

  dynamic "set" {
    for_each = var.enable_tls == true ? [1] : []
    content {
      name  = "alertmanager.ingress.tls"
      value = <<YAML
        - secretName: "imported-cert-${var.project}-${var.env}"
          hosts:
            - ${var.alertmanager_domain_name}
      YAML
    }
  }

  set {
    name  = "alertmanager.ingress.annotations"
    value = yamlencode(
      "nginx.ingress.kubernetes.io/auth-type"=  "basic"
      "nginx.ingress.kubernetes.io/auth-secret"= "alertmanager-basic-auth-${var.project}-${var.env}"
      "nginx.ingress.kubernetes.io/auth-secret-type"= "auth-map"
    )
  }

  #set {
  #  name  = "alertmanager.nodeSelector"
  #  value = var.stack_monitoring_node_selector
  #}

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
    value = var.grafana_admin_password
  }

  set {
    name  = "grafana.ingress.enabled"
    value = var.grafana_install
  }

  set {
    name  = "grafana.ingress.hosts"
    value = var.grafana_domain_name
  }

  dynamic "set" {
    for_each = var.enable_tls == true ? [1] : []
    content {
      name  = "grafana.ingress.tls"
      value = <<YAML
        - secretName: "imported-cert-${var.project}-${var.env}"
          hosts:
            - ${var.grafana_domain_name}
      YAML
    }
  }

  set {
    name  = "grafana.ingress.annotations"
    value = yamlencode(
      "nginx.ingress.kubernetes.io/auth-type"=  "basic"
      "nginx.ingress.kubernetes.io/auth-secret"= "grafana-basic-auth-${var.project}-${var.env}"
      "nginx.ingress.kubernetes.io/auth-secret-type"= "auth-map"
    )
  }

  #set {
  #  name  = "grafana.nodeSelector"
  #  value = var.stack_monitoring_node_selector
  #}


  set {
    name  = "grafana.dashboards"
    value = var.enable_default_grafana_dashboards
  }

  # PROMETHEUS
  set {
    name  = "prometheus.enabled"
    value = var.prometheus_install
  }

  set {
    name  = "prometheus.ingress.enabled"
    value = var.prometheus_install
  }

  set {
    name  = "prometheus.ingress.hosts"
    value = var.prometheus_domain_name
  }

 dynamic "set" {
    for_each = var.enable_tls == true ? [1] : []
    content {
      name  = "prometheus.ingress.tls"
      value = <<YAML
        - secretName: "imported-cert-${var.project}-${var.env}"
          hosts:
            - ${var.prometheus_domain_name}
      YAML
    }
  }

  set {
    name  = "prometheus.ingress.annotations"
    value = yamlencode(
      "nginx.ingress.kubernetes.io/auth-type"=  "basic"
      "nginx.ingress.kubernetes.io/auth-secret"= "prometheus-basic-auth-${var.project}-${var.env}"
      "nginx.ingress.kubernetes.io/auth-secret-type"= "auth-map"
    )
  }

  #set {
  #  name  = "prometheus.prometheusSpec.alertingEndpoints"
  #  value = var.alertmanager_install ? [] : var.alertmanager_use_external
  #}

#  set {
#    name  = "prometheus.prometheusSpec.additionalScrapeConfigs"
#    value = var.prometheus_additional_scrape)
#  }
#
#  set {
#    name  = "prometheus.nodeSelector"
#    value = var.stack_monitoring_node_selector
  #}

  # THANOS

  set {
    name  = "prometheus.thanosService.enabled"
    value = var.thanos_install
  }

  set {
    name  = "prometheus.thanosService.thanosServiceMonitor.enabled"
    value = var.thanos_install
  }

  set {
    name  = "objectStorageConfig.existingSecret.name"
    value = local.thanos_object_store_secret_name
  }

  set {
    name  = "objectStorageConfig.existingSecret.key"
    value = "data"
  }

  #set {
  #  name  = "thanos.nodeSelector"
  #  value = var.stack_monitoring_node_selector
  #}
}
