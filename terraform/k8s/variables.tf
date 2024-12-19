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

# monitoring tools
variable "prometheus_install" {}
variable "grafana_install" {}
variable "alertmanager_install" {}
#variable "thanos_install" {
#  default = false
#}

variable "alertmanager_use_external" {
  default = []
}
variable "alertmanager_config_receivers" {
  default = [
    name = "null"
  ]
}

# opsgenie
variable "opsgenie_token" {}

# provider cycloid
variable "cycloid_api_url" {
  default = "https://http-api.cycloid.io"
}

variable "cycloid_api_key" {
  sensitive = true
}

locals {

  namespace = "stack-monitoring"

}