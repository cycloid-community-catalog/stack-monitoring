# basic_auth credentials canonical
output "prometheus_basic_auth_cred_cannonical" {
  value = var.prometheus_install ? cycloid_credential.prometheus_basic_auth[0].canonical : ""
}

output "grafana_basic_auth_cred_cannonical" {
  value = var.grafana_install ? cycloid_credential.grafana_basic_auth[0].canonical : ""
}

output "alertmanager_basic_auth_cred_cannonicals" {
  value = var.alertmanager_install ? cycloid_credential.alertmanager_basic_auth[0].canonical : ""
}

output "alertmanager_basic_auth_cred_canonicals" {
  value = var.alertmanager_install ? [
    for user, cred in cycloid_credential.alertmanager_basic_auth : cred.canonical
  ] : []
  description = "A list of canonical names for alertmanager credentials"
}