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

variable "access_key" {
  description = "AWS IAM access key ID."
}
variable "secret_key" {
  description = "AWS IAM access secret key."
}
variable "aws_region" {
  description = "AWS region to launch VM."
  default     = "eu-west-1"
}

variable "aws_role_arn" {
  description = "AWS ARN role to assume."
}