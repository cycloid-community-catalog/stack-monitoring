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

# opsgenie
variable "opsgenie_token" {}

#
# AWS
#

# cycloid credentials - passed via pipeline
variable "aws_access_cred" {
  type = map(string)
  default = null
}
variable "aws_region" {
  default = null
}
variable "aws_role_arn" {
  default = null
}

locals {

  namespace = "stack-monitoring"

}