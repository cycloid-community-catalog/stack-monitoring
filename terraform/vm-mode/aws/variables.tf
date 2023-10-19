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
variable "keypair_public" {}