################################################################################
# Secret of opsgenie-heartbeat-gw with Opsgenie token
################################################################################

resource "kubernetes_secret" "opsgenie_heartbeat_gw" {

  count = var.opsgenie_heartbeat_install ? 1 : 0

  metadata {
    name      = "opsgenie-heartbeat-gw"
    namespace = var.namespace
    labels = local.common_labels
  }

  type = "Opaque"

  data = {
    OPSGENIE_TOKEN = var.opsgenie_token
  }
}
