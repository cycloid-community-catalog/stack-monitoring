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
    commonLabels = local.resource_labels
    prometheusOperator = {
      nodeSelector = var.stack_monitoring_node_selector
    }
  }

  # prometheus
  prometheus_helm_vars = {
    defaultRules = {
      labels = local.alert_labels
    }
    customRules = var.prometheus_custom_rules
    additionalPrometheusRulesMap = var.prometheus_additional_rules
    prometheus = {
      nodeSelector = var.stack_monitoring_node_selector
      prometheusSpec = {
        additionalScrapeConfigs = var.prometheus_additional_scrape
        alertingEndpoints = var.alertmanager_use_external
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
        receivers = var.alertmanager_config_receivers
      }
    }
  }
  # grafana
  grafana_helm_vars = {
    grafana = {
      nodeSelector = var.stack_monitoring_node_selector
      dashboards = {
        default = var.grafana_dashboard_import
      }
    }
  }

  ## thanos
  #thanos_helm_vars = {
  #  thanos = {
  #    nodeSelector = var.stack_monitoring_node_selector
  #  }
  #}
}

locals {
# grafana
  #https://github.com/grafana/helm-charts/issues/127#issuecomment-776311048
  #issue with import dashboards
  dashboard_default_provider= <<EOL
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
    yamlencode(local.global_helm_vars),

    # alertmanager
    yamlencode(local.alertmanager_config),

    # grafana
    yamlencode(local.grafana_helm_vars),
    local.dashboard_default_provider,

    # prometheus
    yamlencode(local.prometheus_helm_vars)

    #thanos
    #yamlencode(local.thanos_helm_vars)
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

  #set {
  #  name  = "grafana.ingress.annotations.nginx\\.ingress\\.kubernetes\\.io/auth-type"
  #  value = "basic"
  #}
  #set {
  #  name  = "grafana.ingress.annotations.nginx\\.ingress\\.kubernetes\\.io/auth-secret"
  #  value = "grafana-basic-auth-${var.project}-${var.env}"
  #}
  #set {
  #  name  = "grafana.ingress.annotations.nginx\\.ingress\\.kubernetes\\.io/auth-secret-type"
  #  value = "auth-map"
  #}


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
