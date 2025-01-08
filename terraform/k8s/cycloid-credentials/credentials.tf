###
# Creates the different cycloid credentials required
# - basic auth for the different services
###

# prometheus basic auth
resource "cycloid_credential" "prometheus_basic_auth" {
  count = var.prometheus_install ? 1 : 0
  name                   = "${var.project}-prometheus- ${var.env}"
  organization_canonical = var.organization
  path                   = "${var.project}_prometheus_${var.env}"
  canonical              = "${var.project}-prometheus-${var.env}"
  type                   = "basic_auth"
  body = {
    username = var.prometheus_username
	  password = var.prometheus_password
  }
}

# alertmanager basic auth
resource "cycloid_credential" "alertmanager_basic_auth" {
  count = var.alertmanager_install ? 1 : 0
  name                   = "${var.project}-alertmanager-${var.env}"
  organization_canonical = var.organization
  path                   = "${var.project}_alertmanager_${var.env}"
  canonical              = "${var.project}-alertmanager-${var.env}"
  type                   = "basic_auth"
  body = {
    username = var.alertmanager_username
	  password = var.alertmanager_password
  }
}

# grafana basic auth
resource "cycloid_credential" "grafana_basic_auth" {
  count = var.grafana_install ? 1 : 0
  name                   = "${var.project}-grafana-${var.env}"
  organization_canonical = var.organization
  path                   = "${var.project}_grafana_${var.env}"
  canonical              = "${var.project}-grafana-${var.env}"
  type                   = "basic_auth"
  body = {
    username = var.grafana_username
	  password = var.grafana_password
  }
}
