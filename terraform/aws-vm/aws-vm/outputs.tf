# machine IPs

output "machine_ip_private_address" {
  value = aws_eip.vm.private_ip
}

output "machine_ip_public_address" {
  value = aws_eip.vm.public_ip
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

# basic_auth
output "prometheus_basic_auth_username" {
  sensitive = true
  value     = var.organization
}

output "prometheus_basic_auth_password" {
  sensitive = true
  value     = random_password.prometheus_basic_auth_password.result
}

output "prometheus_basic_auth_httpwd" {
  sensitive = true
  value     = random_password.prometheus_basic_auth_password.bcrypt_hash
}

output "alertmanager_basic_auth_username" {
  sensitive = true
  value     = var.organization
}

output "alertmanager_basic_auth_password" {
  sensitive = true
  value     = random_password.alertmanager_basic_auth_password.result
}

output "alertmanager_basic_auth_httpwd" {
  sensitive = true
  value     = random_password.alertmanager_basic_auth_password.bcrypt_hash
}

output "grafana_basic_auth_username" {
  sensitive = true
  value     = var.organization
}

output "grafana_basic_auth_password" {
  sensitive = true
  value     = random_password.grafana_basic_auth_password.result
}

output "grafana_basic_auth_httpwd" {
  sensitive = true
  value     = random_password.grafana_basic_auth_password.bcrypt_hash
}

# certs

output "enable_tls"{
  value = var.enable_tls
}

output "nginx_cert" {
  sensitive = true
  value     = var.tls_crt != "" ? var.tls_crt : tls_self_signed_cert.cert.cert_pem
}

output "nginx_cert_key" {
  sensitive = true
  value     = var.tls_key != "" ? var.tls_key : tls_private_key.cert.private_key_pem
}


# ssh key

output "ssh_private_key" {
  value     = tls_private_key.ssh_key.private_key_pem
  sensitive = true
}

output "ssh_public_key" {
  value = tls_private_key.ssh_key.public_key_openssh
}