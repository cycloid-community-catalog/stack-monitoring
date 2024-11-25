provider "kubernetes" {
  config_path = var.kubeconfig_filename
}

provider "helm" {
  kubernetes {
    config_path = var.kubeconfig_filename
  }
}

#provider "aws" {
#  alias = "module-thanos"
#
#  access_key = var.aws_access_cred != null ? var.aws_access_cred.access_key : null
#  secret_key = var.aws_access_cred != null ? var.aws_access_cred.secret_key : null
#  region     = var.aws_access_cred != null ? var.aws_region : null
#
#  dynamic "assume_role" {
#    for_each = var.aws_role_arn != "" ? [1] : []
#    content {
#      role_arn = var.aws_role_arn
#    }
#  }
#
#  default_tags {
#    tags = local.common_labels
#  }
#}
