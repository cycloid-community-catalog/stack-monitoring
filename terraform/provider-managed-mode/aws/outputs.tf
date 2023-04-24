################################################################################
# AMP
################################################################################

output "amp_workspace_arn" {
  description = "Amazon Resource Name (ARN) of the workspace"
  value       = module.monitoring.amp_workspace_arn
}

output "amp_workspace_id" {
  description = "Identifier of the workspace"
  value       = module.monitoring.amp_workspace_id
}

output "amp_workspace_prometheus_endpoint" {
  description = "Prometheus endpoint available for this workspace"
  value       = module.monitoring.amp_workspace_prometheus_endpoint
}

################################################################################
# AMG
################################################################################

# Workspace
output "amg_workspace_arn" {
  description = "The Amazon Resource Name (ARN) of the Grafana workspace"
  value       = module.monitoring.amg_workspace_arn
}

output "amg_workspace_id" {
  description = "The ID of the Grafana workspace"
  value       = module.monitoring.amg_workspace_id
}

output "amg_workspace_endpoint" {
  description = "The endpoint of the Grafana workspace"
  value       = module.monitoring.amg_workspace_endpoint
}

output "amg_workspace_grafana_version" {
  description = "The version of Grafana running on the workspace"
  value       = module.monitoring.amg_workspace_grafana_version
}

# License Association
output "amg_license_free_trial_expiration" {
  description = "If `license_type` is set to `ENTERPRISE_FREE_TRIAL`, this is the expiration date of the free trial"
  value       = module.monitoring.amg_license_free_trial_expiration
}

output "amg_license_expiration" {
  description = "If `license_type` is set to `ENTERPRISE`, this is the expiration date of the enterprise license"
  value       = module.monitoring.amg_license_expiration
}

# Workspace API Key
output "amg_workspace_api_keys" {
  description = "The workspace API keys created including their attributes"
  value       = module.monitoring.amg_workspace_api_keys
}

# Workspace IAM Role
output "amg_workspace_iam_role_name" {
  description = "IAM role name of the Grafana workspace"
  value       = module.monitoring.amg_workspace_iam_role_name
}

output "amg_workspace_iam_role_arn" {
  description = "IAM role ARN of the Grafana workspace"
  value       = module.monitoring.amg_workspace_iam_role_arn
}

output "amg_workspace_iam_role_unique_id" {
  description = "Stable and unique string identifying the IAM role"
  value       = module.monitoring.amg_workspace_iam_role_unique_id
}

# Workspace SAML Configuration
output "amg_saml_configuration_status" {
  description = "Status of the SAML configuration"
  value       = module.monitoring.amg_saml_configuration_status
}
