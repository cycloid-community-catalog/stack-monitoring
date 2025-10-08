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

variable "os_image_publisher" {
  default = "debian"
}

variable "os_image_offer" {
  default = "debian-12"
}

variable "os_image_sku" {
  default = "12-gen2"
}

variable "os_image_version" {
  default = "latest"
}

# vm network variables
variable "subnet_id" {}
variable "ssh_ips_to_allow" {}

# vm dns variables
variable "create_dns" {}
variable "install_grafana" {}
variable "install_alertmanager" {}
variable "install_prometheus" {}
variable "azure_dns_zone_name" {
  default = ""
}
variable "prometheus_domain_name" {
  default = ""
}
variable "grafana_domain_name" {
  default = ""
}
variable "alertmanager_domain_name" {
  default = ""
}

locals {
  admin_username = "admin"
  standard_tags = {
    "cycloid.io" = "true"
    env          = var.env
    project      = var.project
    customer     = var.customer
  }
  tags = merge(local.standard_tags, var.extra_tags)
}
