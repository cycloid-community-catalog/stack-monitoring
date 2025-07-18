################################################################################
# Create SSO configuration for Grafana
# For now only Oauth is implemented in this module
# Not  SAML or LDAP
################################################################################

resource "grafana_sso_settings" "github_sso_settings" {
  count = var.sso_enabled ? 1 : 0

  provider_name = var.sso_provider_name

  oauth2_settings {
    name          = var.sso_provider_name
    allow_sign_up = true
    auto_login    = false
    use_pkce      = true

    allowed_domains = var.sso_allowed_domains
    api_url         = var.sso_api_url
    auth_url        = var.sso_auth_url
    client_id       = var.sso_client_id
    client_secret   = var.sso_client_secret
    token_url       = var.sso_token_url
    scopes          = var.sso_scopes

    // roles
    allow_assign_grafana_admin = true
    skip_org_role_sync         = false
    role_attribute_path        = var.sso_role_atribute_path
  }
}
