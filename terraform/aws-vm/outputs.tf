output "machine_ip_private_address" {
  value = module.aws-vm.machine_ip_private_address
}

output "machine_ip_public_address" {
  value = module.aws-vm.machine_ip_public_address
}

output "prometheus_domain_name" {
  value = module.aws-vm.prometheus_domain_name
}

output "grafana_domain_name" {
  value = module.aws-vm.grafana_domain_name
}

output "alertmanager_domain_name" {
  value = module.aws-vm.alertmanager_domain_name
}