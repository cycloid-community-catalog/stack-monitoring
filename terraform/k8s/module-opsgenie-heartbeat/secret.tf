################################################################################
# Secret of opsgenie-heartbeat-gw with Opsgenie token
################################################################################

resource "kubernetes_secret" "opsgenie_heartbeat_gw" {

  count = var.create_opsgenie_heartbeat ? 1 : 0

  metadata {
    name      = "opsgenie-heartbeat-gw"
    namespace = var.namespace
    labels = local.common_labels
  }

  type = "Opaque"

  data = {
    OPSGENIE_TOKEN = base64encode(var.opsgenie_token)
  }
}
