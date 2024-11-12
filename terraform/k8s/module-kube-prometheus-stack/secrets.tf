################################################################################
# Secrets required by helm chart:
# - TLS Secret: certificate secret, to be created and used by helm
# - Basic auth secret: used to login in the different apps
# - Object storage: to be used by thanos to store the monitoring data
################################################################################
# tls secret
resource "kubernetes_secret" "tls_secret" {
  count = var.enable_tls ? 1 : 0

  type = "kubernetes.io/tls"

  metadata {
    name      = "imported-cert-${var.project}-${var.env}"
    namespace = var.namespace
  }

  # base64encode
  data = {
    "tls.crt" = var.tls_crt
    "tls.key" = var.tls_key
  }
}

# basic auth
resource "kubernetes_secret" "prometheus_basic_auth" {

  count = var.prometheus_install ? 1 : 0

  metadata {
    name = "prometheus-basic-auth-${var.project}-${var.env}"
    namespace = var.namespace
  }

  data = {
    "username" = var.prometheus_basic_auth_username
    "password" = var.prometheus_basic_auth_password
  }
}

resource "kubernetes_secret" "alertmanager_basic_auth" {

    count = var.alertmanager_install ? 1 : 0

  metadata {
    name = "alertmanager-basic-auth-${var.project}-${var.env}"
    namespace = var.namespace
  }

  data = {
    "username" = var.alertmanager_basic_auth_username
    "password" = var.alertmanager_basic_auth_password
  }
}

resource "kubernetes_secret" "grafana_basic_auth" {

  count = var.grafana_install ? 1 : 0

  metadata {
    name = "grafana-basic-auth-${var.project}-${var.env}"
    namespace = var.namespace
  }

  data = {
    "username" = var.grafana_basic_auth_username
    "password" = var.grafana_basic_auth_password
  }
}
