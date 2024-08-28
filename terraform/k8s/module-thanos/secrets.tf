################################################################################
# Secrets required by helm chart:
# - TLS Secret: certificate secret, to be created and used by helm with Thanos domain name
# - Thanos S3 Secret: containing information about how to connect to the S3 where the thanos data will be stored
################################################################################
# tls secret
resource "kubernetes_secret" "thanos_tls_secret" {

  count = var.enable_thanos && var.enable_tls ? 1 : 0

  type = "kubernetes.io/tls"

  metadata {
    name      = var.thanos_dns
    namespace = var.namespace
  }

  # base64encode
  data = {
    "tls.crt" = var.tls_crt
    "tls.key" = var.tls_key
  }
}

# thanos s3 secret
resource "kubernetes_secret" "thanos_s3_secret" {

  count = var.enable_thanos ? 1 : 0

  metadata {
    name      = var.thanos_object_store_secret_name
    namespace = var.namespace
  }

  data = {
    type   = "s3"
    config = <<EOF
{
  "bucket": ${aws_s3_bucket.thanos_data[0].id},
  "endpoint": "s3.${aws_s3_bucket.thanos_data[0].region}.amazonaws.com",
  "access_key": "${base64encode(aws_iam_access_key.thanos_data[0].id)}",
  "secret_key": "${base64encode(aws_iam_access_key.thanos_data[0].id)}"
}
EOF
  }
}
