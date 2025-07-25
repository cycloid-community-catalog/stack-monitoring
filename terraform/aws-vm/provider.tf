provider "aws" {
# Conditionally set access keys
  access_key = var.aws_access_cred != "" ? var.aws_access_cred.access_key : null
  secret_key = var.aws_access_cred != "" ? var.aws_access_cred.secret_key : null
  region     = var.aws_region

  # Conditionally assume the role
  dynamic "assume_role" {
    for_each = var.aws_role_arn != "" ? ["enable"] : []
    content {
      role_arn = var.aws_role_arn
      external_id = var.aws_role_external_id != "" ? var.aws_role_external_id : null
    }
  }

  default_tags {
    tags = local.tags
  }
}

provider "cycloid" {
  # The Cycloid API URL to use.
  url = var.cycloid_api_url
  # The Cycloid API key to use.
  jwt = var.cycloid_api_key

  organization_canonical = var.organization
}