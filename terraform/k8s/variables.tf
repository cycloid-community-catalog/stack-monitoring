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

variable "alertmanager_use_external" {}
variable "alertmanager_config_receivers" {
  sensitive   = false
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

variable "namespace"{
  default = "stack-monitoring"
}