provider "aws" {
  access_key = var.access_key
  secret_key = var.secret_key
  region     = var.aws_region

  assume_role {
    role_arn = var.aws_role_arn
  }
}