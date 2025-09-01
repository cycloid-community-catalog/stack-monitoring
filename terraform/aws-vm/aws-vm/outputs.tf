# machine IPs e SGs

output "machine_ip_private_address" {
  value = aws_eip.vm.private_ip
}

output "machine_ip_public_address" {
  value = var.use_public_ip ? aws_eip.vm.public_ip : ""
}

output "machine_id" {
  value = aws_instance.vm.id
}

output "machine_sg_id" {
  value = aws_security_group.vm.id
}

# dns
output "prometheus_domain_name" {
  value = var.prometheus_install ? var.prometheus_domain_name : ""
}

output "grafana_domain_name" {
  value = var.grafana_install ? var.grafana_domain_name : ""
}

output "alertmanager_domain_name" {
  value = var.alertmanager_install ? var.alertmanager_domain_name : ""
}

# basic_auth
output "prometheus_basic_auth_username" {
  sensitive = true
  value     = local.username
}

output "prometheus_basic_auth_password" {
  sensitive = true
  value     = var.prometheus_install ? random_password.prometheus_basic_auth_password[0].result : ""
}

output "prometheus_basic_auth_httpwd" {
  sensitive = true
  value     = var.prometheus_install ? "${local.username}:${random_password.prometheus_basic_auth_password[0].bcrypt_hash}" : ""
}

output "alertmanager_basic_auth_username" {
  sensitive = true
  value     = local.username
}

output "alertmanager_basic_auth_password" {
  sensitive = true
  value     = var.alertmanager_install ? random_password.alertmanager_basic_auth_password[0].result : ""
}

output "alertmanager_basic_auth_httpwd" {
  sensitive = true
  value     = var.alertmanager_install ? "${local.username}:${random_password.alertmanager_basic_auth_password[0].bcrypt_hash}" : ""
}

output "grafana_basic_auth_username" {
  sensitive = true
  value     = local.username
}

output "grafana_basic_auth_password" {
  sensitive = true
  value     = var.grafana_install ? random_password.grafana_basic_auth_password[0].result : ""
}

output "grafana_basic_auth_httpwd" {
  sensitive = true
  value     = var.grafana_install ? "${local.username}:${random_password.grafana_basic_auth_password[0].bcrypt_hash}" : ""
}

# certs

output "enable_tls" {
  value = var.enable_tls
}

output "nginx_cert" {
  value = var.tls_crt != "" ? var.tls_crt : tls_self_signed_cert.cert[0].cert_pem
}

output "nginx_cert_key" {
  value = var.tls_key != "" ? var.tls_key : tls_private_key.cert[0].private_key_pem
}


# ssh key

output "ssh_private_key" {
  value     = var.enable_ssh ? tls_private_key.ssh_key[0].private_key_openssh : ""
  sensitive = true
}

output "ssh_public_key" {
  value = var.enable_ssh ? tls_private_key.ssh_key[0].public_key_openssh : ""
}

# ssm agent

output "s3_bucket_ansible" {
  value = {
    "name"   = aws_s3_bucket.ansible.id
    "region" = aws_s3_bucket.ansible.region
  }
}
