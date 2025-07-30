###
# Creates the different cycloid credentials required
# - basic auth for the different services
###

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
  for_each = var.alertmanager_install ? var.alertmanager_users : {}
  name     = "alertmanager_${local.name_prefix}_${each.key}"
  path     = "alertmanager_${local.name_prefix}_${each.key}"
  type     = "basic_auth"
  body = {
    username = each.key
    password = each.value
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
