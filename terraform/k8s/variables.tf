#
# Credeential variables to be passed as pipeline variables
# Stored inside cycloid credentials
#
# cycloid vars
variable "project" {}
variable "env" {}
variable "organization" {}
variable "component" {}

# kubeconfig to use
variable "kubeconfig_filename" {}

# monitoring tools
variable "prometheus_install" {}
variable "grafana_install" {}
variable "alertmanager_install" {}

# grafana oauth tools
variable "grafana_sso_enabled" {}
variable "grafana_sso_client_id" {}
variable "grafana_sso_client_secret" {}
variable "grafana_sso_provider_name" {}
variable "grafana_sso_allowed_domains" {}
variable "grafana_sso_api_url" {}
variable "grafana_sso_auth_url" {}
variable "grafana_sso_token_url" {}
variable "grafana_sso_scopes" {}
variable "grafana_sso_role_atribute_path" {}
variable "grafana_extra_datasources" {}
variable "prometheus_additional_scrape" {
  default = []
}

variable "alertmanager_use_external" {}
variable "alertmanager_config_receivers" {
  sensitive = false
}
# Receivers given as a list in the form, with secrets as Cycloid URIs resolved
# by the pipeline (cy uri interpolate). Appended to alertmanager_config_receivers.
# Not sensitive, like alertmanager_config_receivers: marking it would make the
# whole Helm values sensitive and hide every plan diff of the chart.
variable "alertmanager_extra_receivers" {
  type    = any
  default = []
}
# opsgenie
variable "opsgenie_token" {}

# provider cycloid
variable "cycloid_api_url" {
  default = "https://http-api.cycloid.io"
}

variable "cycloid_api_key" {
  sensitive = true
}

variable "namespace" {
  default = "stack-monitoring"
}
