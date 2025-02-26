################################################################################
# Deployment of opsgenie-heartbeat-gw
# based on cycloid docker image https://hub.docker.com/r/cycloid/opsgenie-heartbeat-gw
# Requires secret with Opsgenie token
################################################################################

resource "kubernetes_deployment" "opsgenie_heartbeat_gw" {

  count = var.opsgenie_heartbeat_install ? 1 : 0

  metadata {
    name      = "opsgenie-heartbeat-gw"
    namespace = var.namespace
    labels = local.common_labels
  }

  spec {
    replicas = 1

    selector {
      match_labels = local.common_labels
    }

    template {
      metadata {
        labels = local.common_labels
      }

      spec {

        node_selector = var.stack_monitoring_node_selector

        #service_account_name = var.service_account_name

        container {
          name  = "opsgenie-heartbeat-gw"
          image = "cycloid/opsgenie-heartbeat-gw:latest"

          #resources {
          #  limits = {
          #    cpu    = var.opsgenie_heartbeat_cpu_limit
          #    memory = var.opsgenie_heartbeat_memory_limit
          #  }
          #  requests = {
          #    cpu    = var.opsgenie_heartbeat_cpu_request
          #    memory = var.opsgenie_heartbeat_memory_request
          #  }
          #}

          port {
            name           = "http"
            container_port = 5000
          }

          env {
            name = "TOKEN"
            value_from {
              secret_key_ref {
                name = "opsgenie-heartbeat-gw"
                key  = "OPSGENIE_TOKEN"
              }
            }
          }
        }
      }
    }
  }
}