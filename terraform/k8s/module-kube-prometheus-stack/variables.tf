#
# CYCLOID
#
variable "project" {}
variable "env" {}
variable "organization" {}
variable "component" {}

#
# GENERAL VARIABLES
#

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
variable "prometheus_additional_scrape" {
  default = []
}
variable "prometheus_blackbox_scrape" {
  default = []
}
variable "prometheus_rules_namespaces" {
  default = ".*"
}
variable "prometheus_change_default_rules" {
  default = {}
}
variable "prometheus_default_rules_disabled" {
  default = []
}
variable "prometheus_default_alerts_disabled" {
  default = []
}
variable "prometheus_additional_rules" {
  default = {}
}
variable "enable_prometheus_persistence" {
  default = false
}
variable "prometheus_pvc_size" {
  default = "10"
}
variable "prometheus_data_retention" {
  default = "10d"
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
variable "enable_grafana_persistence" {
  default = false
}
variable "grafana_pvc_size" {
  default = "10"
}
variable "grafana_feature_toggles" {
  default = "ssoSettingsApi"
}
variable "grafana_additional_datasources" {
  default = []
}
variable "grafana_alerts" {
  default = {}
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
variable "alertmanager_time_intervals" {}
variable "alertmanager_config_route" {}
variable "alertmanager_config_receivers" {
  sensitive = false
}
variable "enable_alertmanager_persistence" {
  default = false
}
variable "alertmanager_pvc_size" {
  default = "10"
}
variable "alertmanager_data_retention" {
  default = "120h"
}
variable "alertmanager_users" {}


locals {

  # grafana
  #https://github.com/grafana/helm-charts/issues/127#issuecomment-776311048
  #issue with import dashboards
  dashboard_default_provider = <<EOL
---
grafana:
  dashboardProviders:
    dashboardproviders.yaml:
      apiVersion: 1
      providers:
        - name: 'default'
          folder: 'Kubernetes'
          options:
            path: /var/lib/grafana/dashboards/default
EOL

  # prometheus
  # issue with no configuration for labels in defaults alerts.
  # so we have to disable the default dashboard to then set it
  default_watchdog_rule_configured = {
    "watchdog.rules" = {
      groups = [
        {
          name = "watchdog.rules"
          rules = [
            {
              alert = "Watchdog"
              annotations = {
                description = "This is an alert meant to ensure that the entire alerting pipeline is functional."
                runbook_url = "https://runbooks.prometheus-operator.dev/runbooks/general/watchdog"
                summary     = "An alert that should always be firing to certify that Alertmanager is working properly."
              }
              expr = "vector(1)"
              labels = {
                receiver = "opsgenie_heartbeat"
                severity = "critical"
              }
            }
          ]
        }
      ]
    }
  }
  name_prefix = "${var.project}-${var.env}-${var.component}"

  default_resource_labels = {
    env          = "${var.env}"
    project      = "${var.project}"
    organization = "${var.organization}"
    customer     = "${var.organization}"
    component    = "${var.component}"
    stack        = "stack-monitoring"
  }
  resource_labels = merge(local.default_resource_labels, var.extra_labels)

  default_alert_labels = {
    env          = "${var.env}"
    project      = "${var.project}"
    organization = "${var.organization}"
    customer     = "${var.organization}"
    component    = "${var.component}"
    receiver     = "on_call"
  }
  alert_labels = merge(local.default_alert_labels, var.extra_labels)

  default_alerts_disabled = concat(["Watchdog"], var.prometheus_default_alerts_disabled)

  default_rules_disabled = concat([], var.prometheus_default_rules_disabled)

  username = var.organization

  alertmanager_users = concat([local.username], var.alertmanager_users)
}
