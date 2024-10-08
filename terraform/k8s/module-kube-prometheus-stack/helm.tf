################################################################################
# Helm-release: kube-prometheus-stack
# CHART: https://github.com/prometheus-community/helm-charts/blob/main/charts/kube-prometheus-stack
# VALUES: https://raw.githubusercontent.com/prometheus-community/helm-charts/main/charts/kube-prometheus-stack/values.yaml
# NOTE! The value specification follows the order of the values.yaml to be more easy to follow the params setup and add new ones
# todo: backup of configs, extra dashboards grafana
################################################################################

resource "helm_release" "kube_prometheus_stack" {
  name       = "kube-prometheus-stack"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  version    = var.kube_prometheus_helm_version
  namespace  = var.namespace

  values = [
    file("${path.module}/values.yaml"),
  ]
  # GENERAL VARS
  set {
    name  = "commonLabels"
    value = local.common_labels
  }

  dynamic "set" {
    for_each = toset(var.disable_component_scraping)
    content {
      name  = "${set.key}.enabled"
      value = false
    }
  }

  set {
    name  = "prometheusOperator.nodeSelector"
    value = var.stack_monitoring_node_selector
  }

  # ALERTMANAGER
  set {
    name  = "customRules"
    value = var.alertmanager_customRules
  }
  set {
    name  = "additionalPrometheusRulesMap"
    value = var.alertmanager_additional_rules
  }

  set {
    name  = "alertmanager.enabled"
    value = var.enable_alertmanager
  }

  set {
    name  = "alertmanager.config"
    value = var.alertmanager_config
  }

  set {
    name  = "alertmanager.ingress.enabled"
    value = var.enable_alertmanager
  }

  set {
    name  = "alertmanager.ingress.hosts"
    value = var.alertmanager_dns
  }

  dynamic "set" {
    for_each = var.enable_tls == true ? [1] : []
    content {
      name  = "alertmanager.ingress.tls"
      value = <<YAML
        - secretName: "imported-cert-${var.project}-${var.env}"
          hosts:
            - ${var.alertmanager_dns}
      YAML
    }
  }

  set {
    name  = "alertmanager.ingress.annotations"
    value = {
      "nginx.ingress.kubernetes.io/auth-type" = "basic"
      "nginx.ingress.kubernetes.io/auth-secret" = "alertmanager-basic-auth-${var.project}-${var.env}"
      "nginx.ingress.kubernetes.io/auth-secret-type" = "auth-map"
    }
  }

  set {
    name  = "alertmanager.nodeSelector"
    value = var.stack_monitoring_node_selector
  }

  # GRAFANA

  set {
    name  = "grafana.enabled"
    value = var.enable_grafana
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
    value = var.enable_grafana
  }

  set {
    name  = "grafana.ingress.hosts"
    value = var.grafana_dns
  }

  dynamic "set" {
    for_each = var.enable_tls == true ? [1] : []
    content {
      name  = "grafana.ingress.tls"
      value = <<YAML
        - secretName: "imported-cert-${var.project}-${var.env}"
          hosts:
            - ${var.grafana_dns}
      YAML
    }
  }

  set {
    name  = "grafana.ingress.annotations"
    value = {
      "nginx.ingress.kubernetes.io/auth-type" = "basic"
      "nginx.ingress.kubernetes.io/auth-secret" = "grafana-basic-auth-${var.project}-${var.env}"
      "nginx.ingress.kubernetes.io/auth-secret-type" = "auth-map"
    }
  }

  set {
    name  = "grafana.nodeSelector"
    value = var.stack_monitoring_node_selector
  }


  set {
    name  = "grafana.dashboards"
    value = var.enable_default_grafana_dashboards
  }

  # PROMETHEUS
  set {
    name  = "prometheus.enabled"
    value = var.enable_prometheus
  }

  set {
    name  = "prometheus.ingress.enabled"
    value = var.enable_prometheus
  }

  set {
    name  = "prometheus.ingress.hosts"
    value = var.prometheus_dns
  }

 dynamic "set" {
    for_each = var.enable_tls == true ? [1] : []
    content {
      name  = "prometheus.ingress.tls"
      value = <<YAML
        - secretName: "imported-cert-${var.project}-${var.env}"
          hosts:
            - ${var.prometheus_dns}
      YAML
    }
  }

  set {
    name  = "prometheus.ingress.annotations"
    value = {
      "nginx.ingress.kubernetes.io/auth-type" = "basic"
      "nginx.ingress.kubernetes.io/auth-secret" = "prometheus-basic-auth-${var.project}-${var.env}"
      "nginx.ingress.kubernetes.io/auth-secret-type" = "auth-map"
    }
  }

  set {
    name  = "prometheus.prometheusSpec.alertingEndpoints"
    value = var.enable_alertmanager ? [] : var.alertmanager_use_external
  }

  set {
    name  = "prometheus.prometheusSpec.additionalScrapeConfigs"
    value = var.prometheus_additional_scrape
  }

  set {
    name  = "prometheus.nodeSelector"
    value = var.stack_monitoring_node_selector
  }

  # THANOS

  set {
    name  = "prometheus.thanosService.enabled"
    value = var.enable_thanos
  }

  set {
    name  = "prometheus.thanosService.thanosServiceMonitor.enabled"
    value = var.enable_thanos
  }

  set {
    name  = "objectStorageConfig.existingSecret.name"
    value = local.thanos_object_store_secret_name
  }

  set {
    name  = "objectStorageConfig.existingSecret.key"
    value = "data"
  }

  set {
    name  = "thanos.nodeSelector"
    value = var.stack_monitoring_node_selector
  }
}
