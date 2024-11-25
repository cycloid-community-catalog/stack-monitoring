provider "aws" {
  access_key = var.aws_access_cred.access_key != null ? var.aws_access_cred.access_key : null
  secret_key = var.aws_access_cred.secret_key != null ? var.aws_access_cred.secret_key : null
  region     = var.aws_region != null ? var.aws_region : null

  dynamic "assume_role" {
    for_each = var.aws_role_arn != "" ? [1] : []
    content {
      role_arn = var.aws_role_arn
    }
  }

  default_tags {
    tags = local.common_labels
  }
}
