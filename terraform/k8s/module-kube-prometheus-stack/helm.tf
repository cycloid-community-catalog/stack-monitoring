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

  grafana_dashboards= <<EOL
---
grafana:
  dashboards:
    default:
      prometheus-stats:
        # Ref: https://grafana.com/dashboards/14900
        gnetId: 14900
        revision: 1
        datasource: prometheus
EOL

    #value = var.grafana_dashboard_import
  dashboard_provider= <<EOL
---
grafana:
  dashboardProviders:
    dashboardproviders.yaml:
      apiVersion: 1
      providers:
        - name: 'default'
          folder: ''
          options:
            path: /var/lib/grafana/dashboards/default
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

## thanos
#  thanos_node_selector= <<EOL
#---
#thanos:
#  nodeSelector:
#    ${yamlencode(var.stack_monitoring_node_selector)}
#EOL
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
    local.grafana_dashboards,
    local.dashboard_provider,

    # prometheus
    local.prometheus_node_selector,
    local.prometheus_additional_scrape,
    local.alertmanager_use_external,

    #thanos
    #local.thanos_node_selector,

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
    value = "grafana-basic-auth-${var.project}-${var.env}"
  }
  set {
    name  = "alertmanager.ingress.annotations.nginx\\.ingress\\.kubernetes\\.io/auth-secret-type"
    value = "auth-map"
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
    name  = "grafana.ingress.enabled"
    value = var.grafana_install
  }

  set {
    name  = "grafana.ingress.hosts[0]"
    value = var.grafana_domain_name
  }

  set {
    name  = "grafana.ingress.annotations.nginx\\.ingress\\.kubernetes\\.io/auth-type"
    value = "basic"
  }
  set {
    name  = "grafana.ingress.annotations.nginx\\.ingress\\.kubernetes\\.io/auth-secret"
    value = "grafana-basic-auth-${var.project}-${var.env}"
  }
  set {
    name  = "grafana.ingress.annotations.nginx\\.ingress\\.kubernetes\\.io/auth-secret-type"
    value = "auth-map"
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
  # THANOS - disabled for now
  #  set {
  #    name  = "prometheus.thanosService.enabled"
  #    value = var.thanos_install
  #  }
  #
  #  set {
  #    name  = "prometheus.thanosService.thanosServiceMonitor.enabled"
  #    value = var.thanos_install
  #  }
  #
  #  set {
  #    name  = "objectStorageConfig.existingSecret.name"
  #    value = local.thanos_object_store_secret_name
  #  }
  #
  #  set {
  #    name  = "objectStorageConfig.existingSecret.key"
  #    value = "data"
  #  }
}
