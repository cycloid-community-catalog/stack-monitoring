# Cycloid variables
variable "customer" {}
variable "project" {}
variable "env" {}

# aws provider variables
variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "aws_region" {}
variable "aws_role_arn" {
	default = ""
}
# cycloid credentials - passed via pipeline
variable "create_keypair" {}
variable "keypair_name" {}
varibale "ssh_public_key" {}

# cycloid credentials - passed via pipeline
variable "prometheus_domain_name" {}
variable "alertmanager_domain_name" {}
variable "grafana_domain_name" {}