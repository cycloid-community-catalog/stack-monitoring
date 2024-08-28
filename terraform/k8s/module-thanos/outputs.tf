#
# Outputs
#

output "thanos_dns" {
  value = var.thanos_dns
}

output "thanos_bucket" {
  value = aws_s3_bucket.thanos_data[0].id
}

output "thanos_bucket_user" {
  value = aws_iam_user.thanos_data[0].name
}