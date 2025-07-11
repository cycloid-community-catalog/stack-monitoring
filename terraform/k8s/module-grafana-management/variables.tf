# Cycloid variables
variable "organization" {}
variable "project" {}
variable "env" {}

# Grafana SSO configuration
variable "sso_provider_name" {}
variable "sso_enabled" {}
variable "sso_allowed_domains" {}
variable "sso_api_url" {}
variable "sso_auth_url" {}
variable "sso_client_id" {}
variable "sso_client_secret" {}
variable "sso_token_url" {}
variable "sso_scopes" {}
variable "sso_role_atribute_path" {}


locals {
  # gets all files inside /terraform/grafana-dashboards that end in .json
  # the folder is created at merge and config by merging default /grafana-dashboards
  # with the one optionally created by the user
  dashboard_files = fileset("${path.module}/../grafana-dashboards", "**/*.json")
  # creates a map with file -> directory where it is
  # e.g terraform/grafana-dashboard/test/test.json -> [test.json -> test]
  dashboard_paths = {
    for file in local.dashboard_files :
    file => basename(dirname(file))
  }
}
