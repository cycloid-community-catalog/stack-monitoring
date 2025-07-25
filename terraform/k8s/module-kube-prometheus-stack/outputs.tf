#
# Outputs
#

output "prometheus_domain_name" {
  value = var.prometheus_install ? var.prometheus_domain_name : ""
}

output "alertmanager_domain_name" {
  value = var.alertmanager_install ? var.alertmanager_domain_name : ""
}

output "grafana_domain_name" {
  value = var.grafana_install ? var.grafana_domain_name : ""
}

# shared variables with other modules
output "stack_monitoring_node_selector" {
  value = var.stack_monitoring_node_selector
}

output "extra_labels" {
  value = var.extra_labels
}


# basic auth

output "prometheus_basic_auth_username" {
  sensitive = true
  value     = var.prometheus_install ? local.username : ""
}

output "prometheus_basic_auth_password" {
  sensitive = true
  value     = var.prometheus_install ? random_password.prometheus_basic_auth_password[0].result : ""
}

output "alertmanager_basic_auth_users" {
  value = var.alertmanager_install ? {
    for user in local.alertmanager_users :
    user => random_password.alertmanager_basic_auth_password[user].result
  } : {}
  description = "A map of alertmanager usernames to their passwords"
}

output "grafana_basic_auth_username" {
  sensitive = true
  value     = var.grafana_install ? local.username : ""
}

output "grafana_basic_auth_password" {
  sensitive = true
  value     = var.grafana_install ? random_password.grafana_basic_auth_password[0].result : ""
}

output "grafana_cms_to_remove" {
  value = var.grafana_install ? var.grafana_cms_to_remove : []
}