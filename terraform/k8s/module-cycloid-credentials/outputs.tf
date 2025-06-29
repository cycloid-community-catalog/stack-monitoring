# basic_auth credentials canonical
output "prometheus_basic_auth_cred_cannonical" {
  value = var.prometheus_install ? cycloid_credential.prometheus_basic_auth[0].canonical : ""
}

output "grafana_basic_auth_cred_cannonical" {
  value = var.grafana_install ? cycloid_credential.grafana_basic_auth[0].canonical : ""
}

output "alertmanager_basic_auth_cred_cannonicals" {
  value = var.alertmanager_install ? [
    for key in keys(cycloid_credential.alertmanager_basic_auth) :
    cycloid_credential.alertmanager_basic_auth[key].canonical
  ] : []
  description = "A list of canonical names for alertmanager credentials"
}