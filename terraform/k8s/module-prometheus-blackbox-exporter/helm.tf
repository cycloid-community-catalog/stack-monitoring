################################################################################
# Helm-release: blackbox used to monitor url/ingress
################################################################################
# https://github.com/prometheus-community/helm-charts/tree/main/charts/prometheus-blackbox-exporter
#VALUES: https://raw.githubusercontent.com/prometheus-community/helm-charts/main/charts/prometheus-blackbox-exporter/values.yaml

# non string or boolean values cannot be set as value in helm
# https://github.com/hashicorp/terraform-provider-helm/issues/669
# all the map variables need to apply this little trick
locals {
  node_selector= <<EOL
---
node_selector:
    ${yamlencode(var.stack_monitoring_node_selector)}
EOL

  blackbox_exporter_modules= <<EOL
---
config:
  modules:
    ${yamlencode(var.blackbox_exporter_modules)}
EOL
}

resource "helm_release" "prometheus_blackbox" {

  count = var.blackbox_exporter_install ? 1 : 0

  name       = "prometheus-blackbox-exporter"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "prometheus-blackbox-exporter"
  version    = var.blackbox_helm_version
  namespace  = var.namespace

  values = [
    file("${path.module}/values.yaml"),
    local.node_selector,
    local.blackbox_exporter_modules
  ]

  # Fix the service name
  set {
    name  = "fullnameOverride"
    value = "stack-monitoring-blackbox-exporter"
  }

  set {
    name  = "serviceMonitor.enabled"
    value = true
  }

  #set {
  #  name  = "node_selector"
  #  value = var.stack_monitoring_node_selector
  #}

  #set {
  #  name  = "config.modules"
  #  value = var.blackbox_exporter_modules
  #}

}
