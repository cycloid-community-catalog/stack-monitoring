
################################################################################
# Prometheus Module - Allows to configure a AMP Workspace, and a cloudwatch log group to be used by it
# Full configuration details here -> https://github.com/terraform-aws-modules/terraform-aws-managed-service-prometheus
################################################################################

resource "aws_cloudwatch_log_group" "amp" {
  count = var.create_amp_cloudwatch_log_group ? 1 : 0
  name = var.amp_cloudwatch_log_group
  tags = local.merged_tags
}

module "prometheus" {
  source = "terraform-aws-modules/managed-service-prometheus/aws"

  create = var.create_amp

  # AMP workspace
  create_workspace = var.create_amp_workspace
  workspace_alias = var.create_amp_workspace ? var.amp_workspace_name : null
  workspace_id = var.create_amp_workspace ? "" : var.amp_workspace_id

  # AMP Cloudwatch logging
  logging_configuration = !var.create_amp_cloudwatch_log_group ? {}: {log_group_arn = "${aws_cloudwatch_log_group.amp[0].arn}:*"}

  # Alertmanager configuration
  # more info here  https://docs.aws.amazon.com/prometheus/latest/userguide/AMP-alert-manager.html
  alert_manager_definition = var.amp_alertmanager_definition
  # sets of rules to apply on the alertmanager
  rule_group_namespaces = var.amp_alertmanager_rules

  #tags to apply to all resources
  tags = local.merged_tags
}
