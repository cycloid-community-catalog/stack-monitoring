# Cycloid variables
variable "customer" {}
variable "project" {}
variable "env" {}

# general variables
variable "extra_tags" {
  default = {}
}
variable "aws_region" {}
# vm configuration variables
variable "vm_size" {}
variable "keypair_public" {
  default = ""
}
variable "create_keypair" {
  default = false
}
variable "keypair_name" {}
variable "os_disk_size" {}
variable "os_disk_type" {}
variable "optional_iam_policies" {}

# vm network variables
variable "subnet_id" {}
variable "vpc_id" {}
variable "bastion_sg_allow" {
  default = ""
}
variable "ssh_ips_to_allow" {
  default = null
}
variable "vpcs_to_scrape" {
  default = {}
}

# vm dns variables
variable "create_dns" {}
variable "install_grafana" {}
variable "install_alertmanager" {}
variable "install_prometheus" {}
variable "aws_dns_zone_id" {
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
  standard_tags  = {
    "cycloid.io" = "true"
    env          = var.env
    project      = var.project
    customer     = var.customer
  }
  tags = merge(local.standard_tags, var.extra_tags)
}
