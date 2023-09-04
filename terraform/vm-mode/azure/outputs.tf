output "machine_ip_address" {
  value = module.monitoring.machine_ip_address
}

output "nsg_monitoring_scraping_id" {
  value = module.monitoring.nsg_monitoring_scraping_id
}

output "prometheus_domain_name" {
  value = module.monitoring.prometheus_domain_name
}

output "grafana_domain_name" {
  value = module.monitoring.grafana_domain_name
}

output "alertmanager_domain_name" {
  value = module.monitoring.alertmanager_domain_name
}