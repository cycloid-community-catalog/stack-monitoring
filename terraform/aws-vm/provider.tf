provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = var.aws_region

  dynamic "assume_role" {
    for_each = var.aws_role_arn != "" ? [1] : []
    content {
      role_arn     = var.aws_role_arn
    }
  }
}
