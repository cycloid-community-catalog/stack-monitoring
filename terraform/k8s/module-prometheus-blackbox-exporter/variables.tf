#
# Cycloid
#

variable "project" {}
variable "env" {}
variable "organization" {}

#
# Module vars
#
variable "namespace"{}

variable "stack_monitoring_node_selector" {
  default = {}
}

variable "blackbox_exporter_install"{
  default = false
}

variable "blackbox_helm_version"{
  default = "8.17.0"
}
variable "blackbox_exporter_modules"{
  default = []
}

# Certificates

variable "enable_tls" {
  default = true
}
variable "create_self_signed_certificate"{
  default = true
}
variable "tls_crt" {}
variable "tls_key" {}