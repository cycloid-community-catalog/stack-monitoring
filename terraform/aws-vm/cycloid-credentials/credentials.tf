###
# Creates the different cycloid credentials required
# - ssh key
# - basic auth for the different services
###

# ssh key
resource "cycloid_credential" "vm_ssh" {
  count = var.enable_ssh ? 1 : 0
  name  = "ssh_${local.name_prefix}"
  path  = "ssh_${local.name_prefix}"
  type  = "ssh"
  body = {
    ssh_key = chomp(var.vm_private_ssh_key)
  }
}

# prometheus basic auth
resource "cycloid_credential" "prometheus_basic_auth" {
  count = var.prometheus_install ? 1 : 0
  name  = "prometheus_${local.name_prefix}"
  path  = "prometheus_${local.name_prefix}"
  type  = "basic_auth"
  body = {
    username = var.prometheus_username
    password = var.prometheus_password
  }
}

# alertmanager basic auth
resource "cycloid_credential" "alertmanager_basic_auth" {
  count = var.alertmanager_install ? 1 : 0
  name  = "alertmanager_${local.name_prefix}"
  path  = "alertmanager_${local.name_prefix}"
  type  = "basic_auth"
  body = {
    username = var.alertmanager_username
    password = var.alertmanager_password
  }
}

# grafana basic auth
resource "cycloid_credential" "grafana_basic_auth" {
  count = var.grafana_install ? 1 : 0
  name  = "grafana_${local.name_prefix}"
  path  = "grafana_${local.name_prefix}"
  type  = "basic_auth"
  body = {
    username = var.grafana_username
    password = var.grafana_password
  }
}
