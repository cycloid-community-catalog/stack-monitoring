################################################################################
# Secrets required by helm chart:
# - Basic auth secret: used to login in the different apps
# - Object storage: to be used by thanos to store the monitoring data
################################################################################
# basic auth

resource "random_password" "prometheus_basic_auth_password" {
  count = var.prometheus_install ? 1 : 0
  length  = 32
  special = false
}

resource "kubernetes_secret" "prometheus_basic_auth" {

  count = var.prometheus_install ? 1 : 0

  metadata {
    name = "prometheus-basic-auth-${var.project}-${var.env}"
    namespace = var.namespace
  }

  data = {
    "${local.username}" = random_password.prometheus_basic_auth_password[0].bcrypt_hash
  }
}

resource "random_password" "alertmanager_basic_auth_password" {
  for_each = var.alertmanager_install ? toset(local.alertmanager_users) : []
  length  = 32
  special = false
}

resource "kubernetes_secret" "alertmanager_basic_auth" {

  count = var.alertmanager_install

  metadata {
    name = "alertmanager-basic-auth-${var.project}-${var.env}"
    namespace = var.namespace
  }

  data = {
    for user in local.alertmanager_users :
      user => random_password.alertmanager_basic_auth_password[user].bcrypt_hash
  }
}

resource "random_password" "grafana_basic_auth_password" {
  count = var.grafana_install ? 1 : 0
  length  = 32
  special = false
}

resource "kubernetes_secret" "grafana_basic_auth" {

  count = var.grafana_install ? 1 : 0

  metadata {
    name = "grafana-basic-auth-${var.project}-${var.env}"
    namespace = var.namespace
  }

  data = {
    "${local.username}" = random_password.grafana_basic_auth_password[0].bcrypt_hash
  }
}
