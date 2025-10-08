# Cycloid variables
variable "customer" {}
variable "project" {}
variable "env" {}

# azure provider variables { subscription_id, tenant_id, client_id, client_secret, subcription_id }
variable "azure_cred" {}
variable "resource_group_name" {}
variable "resource_group_location" {}

# cycloid credentials - passed via pipeline
variable "keypair_public" {}
