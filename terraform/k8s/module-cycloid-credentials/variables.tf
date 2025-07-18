# Cycloid variables
variable "organization" {}
variable "project" {}
variable "env" {}
variable "component" {}

variable "prometheus_install" {}
variable "prometheus_username" {}
variable "prometheus_password" {}

variable "alertmanager_install" {}
variable "alertmanager_users" {}

variable "grafana_install" {}
variable "grafana_username" {}
variable "grafana_password" {}

locals {
  name_prefix = "${var.project}_${var.env}_${var.component}"
}