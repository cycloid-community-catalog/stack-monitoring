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

# monitoring tools
variable "prometheus_install" {}
variable "grafana_install" {}
variable "alertmanager_install" {}
variable "thanos_install" {}

variable "alertmanager_use_external" {
  default = []
}

# opsgenie
variable "opsgenie_token" {}


locals {

  namespace = "stack-monitoring"

}