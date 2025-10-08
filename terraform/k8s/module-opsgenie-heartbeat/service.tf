################################################################################
# Service of opsgenie-heartbeat-gw
################################################################################

resource "kubernetes_service" "opsgenie_heartbeat_gw" {
  count = var.opsgenie_heartbeat_install ? 1 : 0

  metadata {
    name      = "opsgenie-heartbeat-gw"
    namespace = var.namespace
    labels    = local.common_labels
  }

  spec {
    selector = local.common_labels

    port {
      name        = "http"
      protocol    = "TCP"
      port        = 5000
      target_port = "http"
    }
  }
}
