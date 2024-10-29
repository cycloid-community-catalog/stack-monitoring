# machine IPs

output "machine_ip_private_address" {
  value = aws_eip.vm.private_ip
}

output "machine_ip_public_address" {
  value = aws_eip.vm.public_ip
}

# machine keypair
output "ssh_private_key" {
  value     = trimspace(tls_private_key.vm.private_key_pem)
  sensitive = true
}

output "ssh_public_key" {
  value     = trimspace(tls_private_key.vm.private_key_pem)
  sensitive = true
}

# dns
output "prometheus_domain_name" {
  value = var.prometheus_domain_name
}

output "grafana_domain_name" {
  value = var.grafana_domain_name
}

output "alertmanager_domain_name" {
  value = var.alertmanager_domain_name
}
