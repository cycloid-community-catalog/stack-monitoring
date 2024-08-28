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

variable "stack_monitoring_node_selector" {}

variable "install_blackbox_exporter"{
  default = false
}

variable "blackbox_helm_version"{
  default = "8.17.0"
}
variable "blackbox_exporter_modules"{
  default = []
}

