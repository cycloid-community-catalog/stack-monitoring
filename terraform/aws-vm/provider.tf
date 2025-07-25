provider "aws" {
  access_key = var.aws_access_cred.access_key
  secret_key = var.aws_access_cred.secret_key
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