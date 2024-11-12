#
# Outputs
#

output "prometheus_domain_name" {
  value       = var.prometheus_domain_name
}

output "alertmanager_domain_name" {
  value       = var.alertmanager_domain_name
}

output "grafana_domain_name" {
  value       = var.grafana_domain_name
}

output "stack_monitoring_node_selector" {
  value       = var.stack_monitoring_node_selector
}

output "extra_labels" {
  value       = var.extra_labels
}

# required for thanos module
output "thanos_install" {
  value       = var.thanos_install
}

output "thanos_object_store_secret_name" {
  value       = local.thanos_object_store_secret_name
}

output "k8s_secret_infra_basic_auth_password" {
  sensitive = false
  value     = random_password.k8s_secret_infra_basic_auth_password.result
}