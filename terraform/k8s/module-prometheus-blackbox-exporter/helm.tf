################################################################################
# Helm-release: blackbox used to monitor url/ingress
################################################################################
# https://github.com/prometheus-community/helm-charts/tree/main/charts/prometheus-blackbox-exporter#upgrading-chart
#VALUES: https://raw.githubusercontent.com/prometheus-community/helm-charts/main/charts/prometheus-blackbox-exporter/values.yaml

locals {
  blackbox_helm_vars = {
    fullnameOverride = "blackbox-exporter"
    node_selector    = var.stack_monitoring_node_selector
    serviceMonitor = {
      enabled = true
    }
    config = {
      modules = var.blackbox_exporter_modules
    }
  }
}

resource "helm_release" "prometheus_blackbox" {
  count = var.blackbox_exporter_install ? 1 : 0

  name       = "prometheus-blackbox-exporter"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "prometheus-blackbox-exporter"
  version    = "11.4.2"
  namespace  = var.namespace

  values = [
    # file("${path.module}/values.yaml"),
    yamlencode(local.blackbox_helm_vars),
  ]
}
