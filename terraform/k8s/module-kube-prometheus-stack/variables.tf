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
variable "disable_component_scraping" {
  default = []
}
variable "stack_monitoring_node_selector" {
  default = {}
}

#
# PROMETHEUS
#
variable "prometheus_install" {
  default = true
}
variable "prometheus_domain_name" {
  default = "prometheus.local"
}
variable "prometheus_basic_auth_username" {
  default = "prometheus"
}
variable "prometheus_basic_auth_password" {
  default = "pwdToChange"
}
variable "prometheus_additional_scrape" {}
variable "prometheus_custom_rules" {
    default = {}
}
variable "prometheus_additional_rules" {
  default = {}
}

#
# GRAFANA
#
variable "grafana_install" {
  default = true
}
variable "enable_default_grafana_dashboards" {
  default = true
}
variable "grafana_dashboard_import" {
  default = {}
}
variable "grafana_default_timezone" {
  default = "Europe/Paris"
}
variable "grafana_domain_name" {
  default = "grafana.local"
}
variable "grafana_cms_to_remove" {
  default = []
}

#
# ALERTMANAGER
#
variable "alertmanager_install" {
  default = true
}
variable "alertmanager_use_external" {
  default = []
}
variable "alertmanager_domain_name" {
  default = "alertmanager.local"
}
variable "alertmanager_config_inhibit_rules" {}
variable "alertmanager_config_route" {}
variable "alertmanager_config_receivers" {}

#
# Thanos
#
#variable "thanos_install" {
#  default = false
#}

locals {

  default_resource_labels = {
    env = "${var.env}"
    project = "${var.project}"
    organization = "${var.organization}"
    stack = "stack-monitoring"
  }

  default_alert_labels = {
    env = "${var.env}"
    project = "${var.project}"
    organization = "${var.organization}"
    receiver = "oncall"
  }

  resource_labels = merge(local.default_resource_labels, var.extra_labels)
  alert_labels = merge(local.default_alert_labels, var.extra_labels)
  #thanos_object_store_secret_name = "${var.project}-thanos-object-store-${var.env}"

  username = var.organization
}
