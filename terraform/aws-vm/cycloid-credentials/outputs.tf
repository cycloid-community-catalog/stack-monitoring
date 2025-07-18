# basic_auth credentials canonical
output "prometheus_basic_auth_cred_cannonical" {
  value = var.prometheus_install ? cycloid_credential.prometheus_basic_auth[0].canonical : ""
}

output "alertmanager_basic_auth_cred_cannonical" {
  value = var.alertmanager_install ? cycloid_credential.alertmanager_basic_auth[0].canonical : ""
}

output "grafana_basic_auth_cred_cannonical" {
  value = var.grafana_install ? cycloid_credential.grafana_basic_auth[0].canonical : ""
}

# ssh key
output "ssh_private_key_cred_cannonical" {
  value = var.enable_ssh ? cycloid_credential.vm_ssh[0].canonical : ""
}
