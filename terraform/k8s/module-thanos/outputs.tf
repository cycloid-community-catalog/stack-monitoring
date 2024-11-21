#
# Outputs
#

output "thanos_domain_name" {
  value = var.thanos_domain_name
}

output "thanos_bucket" {
  value = aws_s3_bucket.thanos_data[0].id
}

output "thanos_bucket_user" {
  value = aws_iam_user.thanos_data[0].name
}

output "thanos_basic_auth_username" {
  value = var.organization
}

output "thanos_basic_auth_password" {
  value = random_password.thanos_basic_auth_password[0].result
}