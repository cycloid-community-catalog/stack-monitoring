################################################################################
# Managed Grafana Module: creates grafana workspace and related resources
# Full configuration details here -> https://github.com/terraform-aws-modules/terraform-aws-managed-service-grafana
# NOTE! - users need to be authetificated either with SAML or IAM identity center
#         if manually creating IAM users permissions here: permissions required for users using IAM https://docs.aws.amazon.com/grafana/latest/userguide/authentication-in-AMG-SSO.html
#       - by default grafana workspaces open to all traffic
################################################################################

locals{
  sso_role_associations = {
    "ADMIN" = {
      "group_ids" = var.amg_sso_user_admins
      "user_ids"  = var.amg_sso_group_admins
    }
    "EDITOR" = {
      "group_ids" = var.amg_sso_user_editors
      "user_ids"  = var.amg_sso_group_editors
    }
    "VIEWER" = {
      "group_ids" = var.amg_sso_user_viewers
      "user_ids"  = var.amg_sso_group_viewers
    }

  }
}

module "managed_grafana" {
  source = "terraform-aws-modules/managed-service-grafana/aws"

  # disactivate module
  create = var.create_amg

  # Workspace
  create_workspace          = var.create_amg_workspace
  data_sources              = var.amg_datasources

  # if create workspace is true
  name                      = var.create_amg_workspace ? var.amg_workspace_name : null
  # if create workspace is false
  workspace_id              = var.create_amg_workspace ? "" : var.amg_workspace_id

  # Workspace license association
  associate_license         = var.amg_associate_license
  license_type              = var.amg_associate_license ? var.amg_license_type : "ENTERPRISE_FREE_TRIAL"

  # Account access for workspace
  account_access_type       = var.amg_account_type
  organization_role_name    = var.amg_account_type == "ORGANIZATION" ? var.amg_organization_role_name : null
  organizational_units      = var.amg_account_type == "ORGANIZATION" ? var.amg_organizational_units : []

  # Workspace IAM role (2 usecases)
  permission_type = var.amg_permission_type
  create_iam_role = var.amg_permission_type == "SERVICE_MANAGED" ? true : false
  # 1- using CUSTOMER_MANAGED role
  iam_role_arn = var.amg_permission_type == "CUSTOMER_MANAGED" ? var.amg_iam_role_arn : null
  # 2- using SERVICE_MANAGED role
  iam_role_name                  = var.amg_permission_type == "SERVICE_MANAGED" ? var.amg_iam_role_name : null
  iam_role_path                  = var.amg_permission_type == "SERVICE_MANAGED" ? var.amg_iam_role_path : null
  iam_role_force_detach_policies = var.amg_permission_type == "SERVICE_MANAGED" ? var.amg_iam_role_force_detach_policies : true
  iam_role_max_session_duration  = var.amg_permission_type == "SERVICE_MANAGED" ? var.amg_iam_role_max_session_duration : null
  iam_role_permissions_boundary  = var.amg_permission_type == "SERVICE_MANAGED" ? var.amg_iam_role_permissions_boundary : null
  iam_role_policy_arns           = var.amg_permission_type == "SERVICE_MANAGED" ? var.amg_iam_role_policy_arns : []

  # Authentification types
  authentication_providers  = var.amg_authentication_providers

  # Workspace SAML configuration
  create_saml_configuration    = var.amg_create_saml_configuration
  saml_allowed_organizations   = var.amg_create_saml_configuration && contains(var.amg_authentication_providers, "SAML") ? var.amg_saml_allowed_organizations : []
  saml_admin_role_values       = var.amg_create_saml_configuration && contains(var.amg_authentication_providers, "SAML") ? var.amg_saml_admin_role_values : []
  saml_editor_role_values      = var.amg_create_saml_configuration && contains(var.amg_authentication_providers, "SAML") ? var.amg_saml_editor_role_values : []
  saml_email_assertion         = var.amg_create_saml_configuration && contains(var.amg_authentication_providers, "SAML") ? var.amg_saml_email_assertion : null
  saml_groups_assertion        = var.amg_create_saml_configuration && contains(var.amg_authentication_providers, "SAML") ? var.amg_saml_groups_assertion : null
  saml_login_assertion         = var.amg_create_saml_configuration && contains(var.amg_authentication_providers, "SAML") ? var.amg_saml_login_assertion : null
  saml_name_assertion          = var.amg_create_saml_configuration && contains(var.amg_authentication_providers, "SAML") ? var.amg_saml_name_assertion : null
  saml_org_assertion           = var.amg_create_saml_configuration && contains(var.amg_authentication_providers, "SAML") ? var.amg_saml_org_assertion : null
  saml_role_assertion          = var.amg_create_saml_configuration && contains(var.amg_authentication_providers, "SAML") ? var.amg_saml_role_assertion : null
  saml_idp_metadata_url        = var.amg_create_saml_configuration && contains(var.amg_authentication_providers, "SAML") ? var.amg_saml_idp_metadata_url : null
  saml_login_validity_duration = var.amg_create_saml_configuration && contains(var.amg_authentication_providers, "SAML") ? var.amg_saml_login_validity_duration : null

  # Amazon VPC that contains data sources for your Grafana workspace to connect to
  # will correspond to this format here: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/grafana_workspace#vpc-configuration
  create_security_group = var.amg_create_sg
  vpc_configuration     = {
    subnet_ids         = var.amg_subnets_ids
    security_group_ids = var.amg_create_sg ? [] : try(var.amg_sg_ids, [])
  }
  # In case a SG needs to be created
  security_group_name        = var.amg_create_sg ? var.amg_sg_name : null
  security_group_rules       = var.amg_create_sg ? var.amg_sg_rules : {}

  # Workspace API keys -> Map of workspace API key definitions to create
  workspace_api_keys = {
    viewer = {
      key_name        = "viewer"
      key_role        = "VIEWER"
      seconds_to_live = 3600
    }
    editor = {
      key_name        = "editor"
      key_role        = "EDITOR"
      seconds_to_live = 3600
    }
    admin = {
      key_name        = "admin"
      key_role        = "ADMIN"
      seconds_to_live = 3600
    }
  }


  # Role associations: associate user/group IDS to a role
  role_associations = contains(var.amg_authentication_providers, "AWS_SSO") ? local.sso_role_associations : {}

  # grafana notification alerting
  notification_destinations = var.amg_allow_sns_notifications ? ["SNS"] : []
  configuration = var.amg_allow_sns_notifications ? jsonencode({ unifiedAlerting = {enabled = true}}) : null

  #tags to apply to all resources
  tags = local.merged_tags
}