#
# Outputs
#

output "prometheus_dns" {
  value       = var.prometheus_dns
}

output "alertmanager_dns" {
  value       = var.alertmanager_dns
}

output "grafana_dns" {
  value       = var.grafana_dns
}

output "stack_monitoring_node_selector" {
  value       = var.stack_monitoring_node_selector
}

output "extra_labels" {
  value       = var.extra_labels
}

# required for thanos module
output "enable_thanos" {
  value       = var.enable_thanos
}

output "thanos_object_store_secret_name" {
  value       = local.thanos_object_store_secret_name
}