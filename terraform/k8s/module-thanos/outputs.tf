#
# Outputs
#

output "thanos_domain_name" {
  value = var.thanos_install ? var.thanos_domain_name : ""
}

output "thanos_bucket" {
  value = var.thanos_install ? aws_s3_bucket.thanos_data[0].id : ""
}

output "thanos_bucket_user" {
  value = var.thanos_install ? aws_iam_user.thanos_data[0].name : ""
}

output "thanos_basic_auth_username" {
  sensitive = true
  value = var.thanos_install ? local.username : ""
}

output "thanos_basic_auth_password" {
  sensitive = true
  value = var.thanos_install ? random_password.thanos_basic_auth_password[0].result : ""
}