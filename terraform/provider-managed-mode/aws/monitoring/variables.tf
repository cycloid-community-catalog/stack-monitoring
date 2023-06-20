################################################################################
# CYCLOID REQUIREMENTS
################################################################################
variable "env" {
  description = "Cycloid project name"
}

variable "project" {
  description = "Cycloid environment name"
}

variable "customer" {
  description = "Cycloid customer name"
}
#
#
#################################################################################
## Prometheus Module
#################################################################################

# Module activation
variable "create_amp" {
  description = "Wheter to activate module to create Amazon Managed Prometheus (AMP) and related resources."
  default = true
}

# AMP Workspace configuration
variable "create_amp_workspace" {
  description = "Wheter to create AMP Workspace. If false an existing workspace ID should be provided."
  default = true
}

variable "amp_workspace_name" {
  description = "The AMP Workspace name to create."
  default = "amp-terraform"
}

variable "amp_workspace_id" {
  description = "The AMP Workspace ID to use. This option should only be used when var.create_amp_workspacen is false."
  default = ""
}

# Cloudwatch log group for AMP
variable "create_amp_cloudwatch_log_group" {
  description = "Wheter to create AMP cloudwatch group to be use by the AMP."
  default = true
}

variable "amp_cloudwatch_log_group" {
  description = "The cloudwatch log group name used by AMP."
  default = "amp-terraform"
}

# AMP - alertmanager configuration
variable "amp_alertmanager_definition" {
  description = "The alertmanager definition to apply. You should example definition here https://github.com/terraform-aws-modules/terraform-aws-managed-service-prometheus "
  default = "alertmanager_config: |\n route:\n receiver: 'default'\n receivers:\n - name: 'default'\n"
}

variable "amp_alertmanager_rules" {
  description = "The alertmanager rules to apply. You should example definition here https://github.com/terraform-aws-modules/terraform-aws-managed-service-prometheus "
  default = {}
  # EXAMPLE:
  #{
  #    first = {
  #      name = "${local.name}-01"
  #      data = <<-EOT
  #      groups:
  #        - name: test
  #          rules:
  #          - record: metric:recording_rule
  #            expr: avg(rate(container_cpu_usage_seconds_total[5m]))
  #      EOT
  #    }
  #}
}


#################################################################################
## Grafana Module
#################################################################################

# Module activation
variable "create_amg" {
  description = "Wheter to activate module to create Amazon Managed Grafana (AMG) and related resources."
  default = true
}

# AMG Workspace configuration
variable "create_amg_workspace" {
  description = "Wheter to create AMG Workspace. If false an existing workspace ID should be provided."
  default = true
}

variable "amg_workspace_name" {
  description = "The AMG Workspace name to create."
  default = "amg-terraform"
}

variable "amg_workspace_id" {
  description = "The AMG Workspace ID to use. This option should only be used when var.create_amg_workspacen is false."
  default = ""
}

variable "amg_datasources" {
  description = "The data sources for the workspace. Valid values are AMAZON_OPENSEARCH_SERVICE, ATHENA, CLOUDWATCH, PROMETHEUS, REDSHIFT, SITEWISE, TIMESTREAM, XRAY."
  default = ["CLOUDWATCH", "PROMETHEUS"]
}

# Workspace license association
variable "amg_associate_license" {
  description = "Determines whether a license will be associated with the workspace."
  default = false
}

variable "amg_license_type" {
  description = "The type of license for the workspace license association. Valid values are ENTERPRISE and ENTERPRISE_FREE_TRIAL."
  default = "ENTERPRISE_FREE_TRIAL"
}

# Account access for workspace
variable "amg_account_type" {
  description = "The type of account access for the workspace. Valid values are CURRENT_ACCOUNT and ORGANIZATION."
  default = "CURRENT_ACCOUNT"
}

variable "amg_organization_role_name" {
  description = "The role name that the workspace uses to access resources through Amazon Organizations. Requires amg_account_type=ORGANIZATION."
  default = null
}

variable "amg_organizational_units" {
  description = "The Amazon Organizations organizational units that the workspace is authorized to use data sources from. Requires amg_account_type=ORGANIZATION."
  default = []
}

# Amazon VPC that contains data sources for your Grafana workspace to connect to (in case of private connection)
# will correspond to this format here: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/grafana_workspace#vpc-configuration
variable "amg_subnets_ids" {
  description = "The list of subnet IDs created in the Amazon VPC for your Grafana workspace to connect."
  default = null
}
# create sg to connect to subnets
variable "amg_create_sg" {
  description = "	Determines if a security group is created for your Grafana workspace to connect."
  default = false
}
variable "amg_sg_rules" {
  description = "	The list of security_group rules to apply"
  default = {}
  # EXAMPLE
  #{
  #  egress_postgresql = {
  #  description = "Allow egress to PostgreSQL"
  #  from_port   = 5432
  #  to_port     = 5432
  #  protocol    = "tcp"
  #  cidr_blocks = module.vpc.private_subnets_cidr_blocks
  #  }
  #}
}

variable "amg_sg_name" {
  description = "	The name of the security group to be created for your Grafana workspace to connect."
  default = "amg-terraform"
}

# use existing sg
variable "amg_sg_ids" {
  description = "The list of Amazon EC2 security group IDs attached to the Amazon VPC for your Grafana workspace to connect. Requires amg_create_sg=false"
  default = []
}

# Workspace IAM role (2 usecases)
variable "amg_permission_type" {
  description = "The permission type of the workspace to create IAM roles/policies. Can be SERVICE_MANAGED or CUSTOMER_MANAGED."
  default = "SERVICE_MANAGED"
}

# 1- using CUSTOMER_MANAGED role
variable "amg_iam_role_arn" {
  description = "Existing IAM role ARN for the workspace. Required if amg_permission_type=CUSTOMER_MANAGED is set to false."
  default = null
}
# 2- using SERVICE_MANAGED role
variable "amg_iam_role_name" {
  description = "Name to use for the workspace IAM role created."
  default = "amg-terraform"
}

variable "amg_iam_role_path" {
  description = "Name to use for the workspace IAM role created."
  default = "/grafana/"
}

variable "amg_iam_role_force_detach_policies" {
  description = "Determines whether the workspace IAM role policies will be forced to detach."
  default = true
}

variable "amg_iam_role_max_session_duration" {
  description = "Maximum session duration (in seconds) that you want to set for the IAM role. Value has to be between 1h(3600s)-12h(43200s)."
  default=3600
}

variable "amg_iam_role_permissions_boundary" {
  description = "ARN of the policy that is used to set the permissions boundary for the IAM role."
  default = null
}

variable "amg_iam_role_policy_arns" {
  description = "List of ARNs of IAM policies to attach to the workspace IAM role."
  default = []
}

# Authentification types

# authentification type: SAML configuration
variable "amg_create_saml_configuration" {
  description = "Determines whether the SAML configuration will be created."
  default = false
}

variable "amg_saml_allowed_organizations" {
  description = "SAML authentication allowed organizations."
  default = []
}

variable "amg_saml_admin_role_values" {
  description = "SAML authentication admin role values."
  default = []
}

variable "amg_saml_editor_role_values" {
  description = "SAML authentication editor role values."
  default = []
}

variable "amg_saml_login_assertion" {
  description = "SAML authentication login assertion."
  default = null
}

variable "amg_saml_email_assertion" {
  description = "SAML authentication email assertion."
  default = null
}

variable "amg_saml_groups_assertion" {
  description = "SAML authentication groups assertion."
  default = null
}

variable "amg_saml_name_assertion" {
  description = "SAML authentication name assertion."
  default = null
}

variable "amg_saml_org_assertion" {
  description = "SAML authentication org assertion."
  default = null
}

variable "amg_saml_role_assertion" {
  description = "SAML authentication role assertion."
  default = null
}

variable "amg_saml_idp_metadata_url" {
  description = "SAML authentication IDP Metadata URL."
  default = null
}

variable "amg_saml_login_validity_duration" {
  description = "SAML authentication login validity duration."
  default = null
}

# authentification type: SSO configuration
variable "amg_create_sso_configuration" {
  description = "Determines whether to use SSO authentification."
  default = false
}

# Role associations - Map of maps to assocaite user/group IDs to a role. Map key can be used as the role
# Admin role users
variable "amg_sso_user_admins" {
  description = "The AWS SSO user ids to be assigned the admin role. Requires amg_authentication_providers=AWS_SSO"
  default = []
}

variable "amg_sso_group_admins" {
  description = "The AWS SSO group ids to be assigned the admin role.Requires amg_authentication_providers=AWS_SSO "
  default = []
}

# Editor role users
variable "amg_sso_user_editors" {
  description = "The AWS SSO user ids to be assigned the editor role. Requires amg_authentication_providers=AWS_SSO"
  default = []
}

variable "amg_sso_group_editors" {
  description = "The AWS SSO group ids to be assigned the editor role.Requires amg_authentication_providers=AWS_SSO "
  default = []
}

# Editor role users
variable "amg_sso_user_viewers" {
  description = "The AWS SSO user ids to be assigned the viewer role. Requires amg_authentication_providers=AWS_SSO"
  default = []
}

variable "amg_sso_group_viewers" {
  description = "The AWS SSO group ids to be assigned the viewer role.Requires amg_authentication_providers=AWS_SSO "
  default = []
}

# grafana notification alerting
variable "amg_allow_sns_notifications" {
  description = "Wheter to send notifications to SNS."
  default = false
}

#################################################################################
## Tags
#################################################################################
variable "extra_tags" {
  description = "A map of tags to assign, to the resources created, besides the default ones defined by the stack."
  default     = {}
}

locals {
  	default_tags = {
    "cycloid.io" = "true"
    env          = var.env
    project      = var.project
    client       = var.customer
    organization = var.customer
  }
  merged_tags        = merge(var.extra_tags, local.default_tags)


  saml_provider = var.amg_create_saml_configuration == true ? concat([], ["SAML"]) : []
  amg_authentication_providers = var.amg_create_sso_configuration == true ? concat(local.saml_provider, ["AWS_SSO"]) : local.saml_provider

  vpc_configuration = var.amg_subnets_ids != [] ? merge({}, {subnet_ids = var.amg_subnets_ids,security_group_ids = var.amg_sg_ids}) : {}

  admin_user = var.amg_sso_user_admins != [] ? {"user_ids" = var.amg_sso_user_admins } : {}
  admin_user_and_group = var.amg_sso_group_admins != [] ? merge(local.admin_user, {"group_ids" = var.amg_sso_group_admins }) : local.admin_user

  editor_user = var.amg_sso_user_editors != [] ? {"group_ids" = var.amg_sso_user_editors} : {}
  editor_user_and_group = var.amg_sso_group_editors != [] ? merge(local.editor_user, {"group_ids" = var.amg_sso_group_editors }) : local.viewer_user

  viewer_user = var.amg_sso_user_viewers != [] ? {"user_ids" = var.amg_sso_user_viewers} : {}
  viewer_user_and_group = var.amg_sso_group_viewers != [] ? merge(local.viewer_user, {"group_ids" = var.amg_sso_group_viewers }) : local.viewer_user


  sso_role_associations = {
    "ADMIN" = local.admin_user_and_group

    "EDITOR" = local.admin_user_and_group

    "VIEWER" = local.viewer_user_and_group
  }
}