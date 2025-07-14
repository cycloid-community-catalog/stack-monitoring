# Cycloid variables
variable "organization" {}
variable "project" {}
variable "env" {}

variable "enable_ssh" {
  default = false
}
variable "vm_private_ssh_key" {}

variable "prometheus_install" {}
variable "prometheus_username" {}
variable "prometheus_password" {}

variable "alertmanager_install" {}
variable "alertmanager_username" {}
variable "alertmanager_password" {}

variable "grafana_install" {}
variable "grafana_username" {}
variable "grafana_password" {}

variable "use_ssm_agent" {
  default = true
}