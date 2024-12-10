provider "aws" {
  access_key = var.aws_access_cred.access_key
  secret_key = var.aws_access_cred.secret_key
  region     = var.aws_region

  dynamic "assume_role" {
    for_each = var.aws_role_arn != "" ? { "role" = var.aws_role_arn } : {}

    content {
      role_arn = each.value
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

  organization_canonical = "cycloid-io"
}