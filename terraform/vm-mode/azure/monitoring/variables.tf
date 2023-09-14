# Cycloid variables
variable "customer" {}
variable "project" {}
variable "env" {}

# general azure variables
variable "resource_group_name" {}
variable "location" {}
variable "extra_tags" {
  default = {}
}

# vm configuration variables
variable "vm_size" {}
variable "keypair_public" {}
variable "os_disk_size" {}
variable "os_admin_username" {
  default = ""
}
variable "managed_disk_size" {}

# vm network variables
variable "subnet_id" {}
variable "ssh_ips_to_allow" {}

# vm dns variables
variable "create_dns" {}
variable "azure_dns_zone_name" {}
variable "prometheus_domain_name" {}
variable "grafana_domain_name" {}
variable "alertmanager_domain_name" {}

locals {
  admin_username = var.os_admin_username == "" ? var.customer : var.os_admin_username
  standard_tags  = {
    "cycloid.io" = "true"
    env          = var.env
    project      = var.project
    customer     = var.customer
  }
  tags = merge(local.standard_tags, var.extra_tags)
}
