################################################################################
# Secrets required by helm chart:
# - TLS Secret: certificate secret, to be created and used by helm
# - Basic auth secret: used to login in the different apps
# - Object storage: to be used by thanos to store the monitoring data
################################################################################
# tls secret

resource "tls_private_key" "cert" {
  count = (var.enable_tls && var.create_self_signed_certificate) : 1 ? 0
  algorithm = "ED25519"
}

resource "tls_self_signed_cert" "cert" {
  key_algorithm   = tls_private_key.cert.algorithm
  private_key_pem = tls_private_key.cert.private_key_pem

  # Certificate expires after 1 year (365×24)
  validity_period_hours = 8760

  # Generate a new certificate if Terraform is run within 6 months before expiration
  early_renewal_hours = 4380

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]
}

resource "kubernetes_secret" "tls_secret" {
  count = var.enable_tls ? 1 : 0

  type = "kubernetes.io/tls"

  metadata {
    name      = "imported-cert-${var.project}-${var.env}"
    namespace = var.namespace
  }

  # base64encode
  data = {
    "tls.crt" = var.tls_crt != "" ? var.tls_crt : tls_self_signed_cert.cert.cert_pem
    "tls.key" = var.tls_key != "" ? var.tls_key : tls_private_key.cert.private_key_pem
  }
}

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
    "${var.organization}" = random_password.prometheus_basic_auth.bcrypt_hash
  }
}

resource "random_password" "alertmanager_basic_auth_password" {
  count = var.alertmanager_install ? 1 : 0
  length  = 32
  special = false
}

resource "kubernetes_secret" "alertmanager_basic_auth" {

    count = var.alertmanager_install ? 1 : 0

  metadata {
    name = "alertmanager-basic-auth-${var.project}-${var.env}"
    namespace = var.namespace
  }

  data = {
    "${var.organization}" = random_password.alertmanager_basic_auth_password.bcrypt_hash
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
    "${var.organization}" = random_password.grafana_basic_auth_password.bcrypt_hash
  }
}
