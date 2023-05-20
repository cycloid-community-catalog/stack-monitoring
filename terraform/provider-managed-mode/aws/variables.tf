################################################################################
# Cycloid Requirements
################################################################################

variable "env" {
  description = "Cycloid project name."
}

variable "project" {
  description = "Cycloid environment name."
}

variable "customer" {
  description = "Cycloid customer name."
}

################################################################################
# AWS variables -> passed via concourse pipeline
################################################################################

variable "aws_access_key" {
  description = "AWS IAM access key ID."
}
variable "aws_secret_key" {
  description = "AWS IAM access secret key."
}
variable "aws_region" {
  description = "AWS region to launch VM."
  default     = "eu-west-1"
}

variable "aws_role_arn" {
  description = "AWS ARN role to assume."
}

variable "amp_alertmanager_definition" {
  description = "The alertmanager definition to apply. You should example definition here https://github.com/terraform-aws-modules/terraform-aws-managed-service-prometheus "
}

variable "amp_alertmanager_rules" {
  description = "The alertmanager rules to apply. You should example definition here https://github.com/terraform-aws-modules/terraform-aws-managed-service-prometheus "
}