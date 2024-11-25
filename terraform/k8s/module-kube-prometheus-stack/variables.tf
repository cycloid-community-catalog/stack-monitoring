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

# Certificates

variable "enable_tls" {
  default = true
}
variable "create_self_signed_certificate"{
  default = true
}
variable "tls_crt" {}
variable "tls_key" {}

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


#
# GRAFANA
#
variable "grafana_install" {
  default = true
}

variable "enable_default_grafana_dashboards" {
  default = true
}

variable "grafana_default_timezone" {
  default = "Europe/Paris"
}

variable "grafana_domain_name" {
  default = "grafana.local"
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

variable "alertmanager_customRules" {}

variable "alertmanager_additional_rules" {}

variable "alertmanager_config" {}

#
# Thanos
#
variable "thanos_install" {
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

  username = var.organization
}
