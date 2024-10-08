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
variable "os_disk_size" {}
variable "os_disk_type" {
  default = "gp3"
}
variable "create_keypair" {
  default = false
}
variable "keypair_name" {}
variable "ssh_public_key" {
  default = ""
}

variable "optional_iam_policies" {
  default = []
}

# vm network variables
variable "subnet_id" {}
variable "vpc_id" {}
variable "bastion_sg_allow" {
  default = ""
}
variable "ssh_ips_to_allow" {
  type = list(string)
  default = []
}

variable "vpcs_to_scrape" {
  type = list(string)
  default = []
}

variable "scraping_ports" {
  type    = list(number)
  default = [] # Extra prometheus ports besides the default one TODO
}

# vm dns variables
variable "create_dns" {
  default = false
}
#variable "install_grafana" {}
variable "alertmanager_skip_install" {}
variable "prometheus_skip_install" {}
variable "grafana_skip_install" {}
variable "aws_dns_zone_id" {
  default = ""
}
variable "prometheus_domain_name" {
  default = "prometheus.local"
}
variable "grafana_domain_name" {
  default = "grafana.local"
}
variable "alertmanager_domain_name" {
  default = "alertmanager.local"
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
