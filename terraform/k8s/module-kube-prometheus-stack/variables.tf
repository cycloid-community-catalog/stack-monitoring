#
# CYCLOID
#
variable "project" {}
variable "env" {}
variable "organization" {}

#
# GENERAL VARIABLES
#
variable "kube_prometheus_helm_version" {
  default = "59.0.0"
}
variable "namespace" {}

variable "extra_labels" {
  default = {}
}

variable "disable_component_scraping" {}

variable "stack_monitoring_node_selector" {}

variable "enable_tls" {
  default = false
}
variable "tls_crt" {}
variable "tls_key" {}

#
# PROMETHEUS
#
variable "enable_prometheus" {
  default = true
}
variable "prometheus_dns" {
  default = "prometheus.local"
}

variable "prometheus_basic_auth_username" {
  default = "prometheus"
}

variable "prometheus_basic_auth_password" {
  default = "pwdToChange"
}

variable "prometheus_additional_scrape" {}


#
# GRAFANA
#
variable "enable_grafana" {
  default = true
}

variable "enable_default_grafana_dashboards" {
  default = true
}

variable "grafana_default_timezone" {
  default = "Europe/Paris"
}

variable "grafana_admin_password" {
  default = "adminPWD"
}

variable "grafana_dns" {
  default = "grafana.local"
}

variable "grafana_basic_auth_username" {
  default = "grafana"
}

variable "grafana_basic_auth_password" {
  default = "pwdToChange"
}

#
# ALERTMANAGER
#
variable "enable_alertmanager" {
  default = true
}

variable "alertmanager_use_external" {}

variable "alertmanager_dns" {
  default = "alertmanager.local"
}

variable "alertmanager_basic_auth_username" {
  default = "alertmanager"
}

variable "alertmanager_basic_auth_password" {
  default = "pwdToChange"
}

variable "alertmanager_customRules" {}

variable "alertmanager_additional_rules" {}

variable "alertmanager_config" {}

#
# Thanos
#
variable "enable_thanos" {
  default = false
}

locals {

  default_labels = {
    env = "${var.env}"
    project = "${var.project}"
    stack = "stack-monitoring"
  }
  common_labels = merge(local.default_labels, var.extra_labels)

  thanos_object_store_secret_name = "${var.project}-thanos-object-store-${var.env}"
}
