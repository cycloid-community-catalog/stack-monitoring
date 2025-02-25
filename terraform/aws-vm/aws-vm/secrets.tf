###
# Creates the different secret information required
# - tls self signed if not passed in pipeline
# - ssh key
# - basic auth for the different services
# if status check failed twice during 60 seconds
###

# SSH KEY
resource "tls_private_key" "ssh_key" {
  count = var.use_bastion ? 0 : 1
  algorithm = "RSA"
}

## create keypair
# import bastion key
resource "aws_key_pair" "vm" {
  key_name   = "${var.organization}-vm-monitoring-${var.env}"
  public_key = var.use_bastion ? var.bastion_public_ssh_key : tls_private_key.ssh_key[0].public_key_openssh
}

# self signed certificate
resource "tls_private_key" "cert" {
  count = (var.enable_tls && var.create_self_signed_certificate) ? 1 : 0
  algorithm = "RSA"
}

resource "tls_self_signed_cert" "cert" {
  count = (var.enable_tls && var.create_self_signed_certificate) ? 1 : 0
  private_key_pem = tls_private_key.cert[0].private_key_pem

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

# basic auth

resource "random_password" "prometheus_basic_auth_password" {
  count = var.prometheus_install ? 1 : 0
  length  = 32
  special = false
}

resource "random_password" "alertmanager_basic_auth_password" {
  count = var.alertmanager_install ? 1 : 0
  length  = 32
  special = false
}

resource "random_password" "grafana_basic_auth_password" {
  count = var.grafana_install ? 1 : 0
  length  = 32
  special = false
}
