#
# Credeential variables to be passed as pipeline variables
# Stored inside cycloid credentials
#
# cycloid vars
variable "project" {}
variable "env" {}
variable "organization" {}

# kubeconfig to use
variable "kubeconfig_filename" {}

# tls configuration
variable "enable_tls" {
  default = false
}
variable "tls_crt" {}
variable "tls_key" {}

# prometheus - basic auth + declare alertmanager when using external
variable "prometheus_basic_auth_username" {
  default = "prometheus"
}

variable "prometheus_basic_auth_password" {
  default = "pwdToChange"
}

variable "alertmanager_use_external" {
  default = []
}

# grafana - basic auth
variable "grafana_admin_password" {
  default = "adminPWD"
}
variable "grafana_basic_auth_username" {
  default = "grafana"
}

variable "grafana_basic_auth_password" {
  default = "pwdToChange"
}

# alertmanager - basic auth
variable "alertmanager_basic_auth_username" {
  default = "alertmanager"
}

variable "alertmanager_basic_auth_password" {
  default = "pwdToChange"
}

# thanos

variable "thanos_basic_auth_username" {
  default = "thanos"
}
variable "thanos_basic_auth_password" {
  default = "pwdToChange"
}

# opsgenie
variable "opsgenie_token" {}


locals {

  namespace = "stack-monitoring"

}