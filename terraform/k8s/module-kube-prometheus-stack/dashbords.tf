resource "kubernetes_config_map" "exclude_dashboards" {
  for_each = toset([
    "kube-prometheus-stack-alertmanager-overview"
  ])

  metadata {
    name      = each.key
    namespace = var.namespace
  }

  lifecycle {
    prevent_destroy = false
  }
}