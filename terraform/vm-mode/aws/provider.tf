provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = var.aws_region

  assume_role {
    role_arn = var.aws_role_arn
  }
}
