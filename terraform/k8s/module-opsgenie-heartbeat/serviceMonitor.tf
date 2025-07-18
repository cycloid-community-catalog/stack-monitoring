
resource "kubernetes_manifest" "opsgenie_heartbeat_gw_servicemonitor" {

  count = var.opsgenie_heartbeat_install ? 1 : 0

  manifest = {
    apiVersion = "monitoring.coreos.com/v1"
    kind       = "ServiceMonitor"
    metadata = {
      name      = "opsgenie-heartbeat-gw"
      namespace = var.namespace
      labels    = local.common_labels
    }
    spec = {
      endpoints = [{
        interval = "1m" # value increased to avoid failure issues in pod opsgenie
        port     = "http"
      }]
      selector = {
        matchLabels = local.common_labels
      }
    }
  }
}