# TODO
# check grafana provider to create dashboards
# https://aws-observability.github.io/observability-best-practices/recipes/recipes/amg-automation-tf/
#
#provider "grafana" {
#  url  = "INSERT YOUR GRAFANA WORKSPACE URL HERE"
#  auth = "INSERT YOUR API KEY HERE"
#}
#
#resource "grafana_data_source" "prometheus" {
#  type          = "prometheus"
#  name          = "amp"
#  is_default    = true
#  url           = "INSERT YOUR AMP WORKSPACE URL HERE "
#  json_data {
#    http_method     = "POST"
#    sigv4_auth      = true
#    sigv4_auth_type = "workspace-iam-role"
#    sigv4_region    = "eu-west-1"
#  }
#}