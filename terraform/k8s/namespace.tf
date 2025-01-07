################################################################################
# Namespace to be used by stack
################################################################################

resource "kubernetes_namespace" "stack-monitoring" {
  metadata {
    name = var.namespace
  }
}