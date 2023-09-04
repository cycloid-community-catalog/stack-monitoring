output "machine_ip_address" {
  value = azurerm_public_ip.vm.ip_address
}

output "nsg_monitoring_scraping_id" {
  value = azurerm_network_security_group.scraping.id
}

output "prometheus_domain_name" {
  value = var.prometheus_domain_name
}

output "grafana_domain_name" {
  value = var.grafana_domain_name
}

output "alertmanager_domain_name" {
  value = var.alertmanager_domain_name
}
