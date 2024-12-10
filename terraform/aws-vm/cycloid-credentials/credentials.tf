###
# Creates the different cycloid credentials required
# - ssh key
# - basic auth for the different services
###

# ssh key
resource "cycloid_credential" "vm_ssh" {
  name                   = "Monitoring machine SSH : ${var.project} - ${var.env} "
  organization_canonical = var.organization
  path                   = "${var.project}_vm_ssh_${var.env}"
  canonical              = "${var.project}-vm-ssh-${var.env}"
  type                   = "ssh"
  body = {
    ssh_key = var.vm_private_ssh_key
  }
}

# prometheus basic auth
resource "cycloid_credential" "prometheus_basic_auth" {
  count = var.prometheus_install ? 1 : 0
  name                   = "Prometheus Basic Auth : ${var.project} - ${var.env} "
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
  name                   = "Alertmanager Basic Auth : ${var.project} - ${var.env} "
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
  name                   = "Grafana Basic Auth : ${var.project} - ${var.env} "
  organization_canonical = var.organization
  path                   = "${var.project}_grafana_${var.env}"
  canonical              = "${var.project}-grafana-${var.env}"
  type                   = "basic_auth"
  body = {
    username = var.grafana_username
	  password = var.grafana_password
  }
}
