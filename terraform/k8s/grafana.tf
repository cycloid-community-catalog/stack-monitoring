# temporary because of stackforms issue
# The HCL Config is invalid: error decoding HCL config: module.kube-prometheus: module variables must be three parts: module.name.attr in: ${module.kube-prometheus}
module "grafana-management" {
  #####################################
  # Do not modify the following lines #
  source       = "./module-grafana-management"
  project      = var.project
  env          = var.env
  organization = var.organization
  #####################################

  depends_on = [module.kube-prometheus]

  # Grafana OAuth SSO configuration
  sso_provider_name = var.grafana_sso_provider_name
  sso_enabled = var.grafana_sso_enabled
  sso_allowed_domains = var.grafana_sso_provider_name
  sso_client_id = var.grafana_sso_client_id
  sso_client_secret = var.grafana_sso_client_secret
  sso_api_url = var.grafana_sso_api_url
  sso_auth_url = var.grafana_sso_auth_url
  sso_token_url = var.grafana_sso_token_url
  sso_scopes = var.grafana_sso_scopes
}