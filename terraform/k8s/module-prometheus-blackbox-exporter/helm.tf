################################################################################
# Helm-release: blackbox used to monitor url/ingress
################################################################################
# https://github.com/prometheus-community/helm-charts/tree/main/charts/prometheus-blackbox-exporter
#VALUES: https://raw.githubusercontent.com/prometheus-community/helm-charts/main/charts/prometheus-blackbox-exporter/values.yaml

# non string or boolean values cannot be set as value in helm
# https://github.com/hashicorp/terraform-provider-helm/issues/669
# all the map variables need to apply this little trick
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
  version    = "8.17.0"
  namespace  = var.namespace

  values = [
    # file("${path.module}/values.yaml"),
    yamlencode(local.blackbox_helm_vars),
  ]
}
