# machine IPs

output "machine_ip_private_address" {
  value = module.aws-vm.machine_ip_private_address
}

output "machine_ip_public_address" {
  value = module.aws-vm.machine_ip_public_address
}

output "machine_id" {
  value = module.aws-vm.machine_id
}

output "machine_sg_id" {
  value = module.aws-vm.machine_sg_id
}

# DNS
output "prometheus_domain_name" {
  value = module.aws-vm.prometheus_domain_name
}

output "grafana_domain_name" {
  value = module.aws-vm.grafana_domain_name
}

output "alertmanager_domain_name" {
  value = module.aws-vm.alertmanager_domain_name
}

# basic_auth
output "prometheus_basic_auth_username" {
  sensitive = true
  value     = module.aws-vm.prometheus_basic_auth_username
}

output "prometheus_basic_auth_password" {
  sensitive = true
  value     = module.aws-vm.prometheus_basic_auth_password
}

output "prometheus_basic_auth_httpwd" {
  sensitive = true
  value     = module.aws-vm.prometheus_basic_auth_httpwd
}

output "alertmanager_basic_auth_username" {
  sensitive = true
  value     = module.aws-vm.alertmanager_basic_auth_username
}

output "alertmanager_basic_auth_password" {
  sensitive = true
  value     = module.aws-vm.alertmanager_basic_auth_password
}

output "alertmanager_basic_auth_httpwd" {
  sensitive = true
  value     = module.aws-vm.alertmanager_basic_auth_httpwd
}

output "grafana_basic_auth_username" {
  sensitive = true
  value     = module.aws-vm.grafana_basic_auth_username
}

output "grafana_basic_auth_password" {
  sensitive = true
  value     = module.aws-vm.grafana_basic_auth_password
}

output "grafana_basic_auth_httpwd" {
  sensitive = true
  value     = module.aws-vm.grafana_basic_auth_httpwd
}

# certs
output "enable_tls" {
  value = module.aws-vm.enable_tls
}

output "nginx_cert" {
  sensitive = true
  value     = module.aws-vm.nginx_cert
}

output "nginx_cert_key" {
  sensitive = true
  value     = module.aws-vm.nginx_cert_key
}


# ssh key

output "ssh_private_key" {
  value     = module.aws-vm.ssh_private_key
  sensitive = true
}

output "ssh_public_key" {
  value = module.aws-vm.ssh_public_key
}

output "ssh_private_key_cred_cannonical" {
  value = module.cycloid-credentials.ssh_private_key_cred_cannonical
}

# credentials canonical
output "prometheus_basic_auth_cred_cannonical" {
  value = module.cycloid-credentials.prometheus_basic_auth_cred_cannonical
}

output "alertmanager_basic_auth_cred_cannonical" {
  value = module.cycloid-credentials.alertmanager_basic_auth_cred_cannonical
}

output "grafana_basic_auth_cred_cannonical" {
  value = module.cycloid-credentials.grafana_basic_auth_cred_cannonical
}

# ssm agent

output "s3_bucket_ansible" {
  value = module.aws-vm.s3_bucket_ansible
}
