###
# Creates the S3 bucket used for communication fo ansible and the instances when ssm agent installed
# The ansible connection is done using this module https://docs.ansible.com/ansible/latest/collections/community/aws/aws_ssm_connection.html
# This module will generate a presigned URL for S3 from the controller, and then will pass that URL to the target over SSM,
# telling the target to download/upload from S3 with curl.
###

resource "aws_s3_bucket" "ansible" {
  bucket = local.name_prefix

  tags = {
    Role = "ansible"
  }
}

data "aws_iam_policy_document" "ansible_secure_transport" {
  statement {
    sid    = "DenyInsecureTransport"
    effect = "Deny"

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions = ["s3:*"]

    resources = [
      "arn:aws:s3:::${aws_s3_bucket.ansible.id}",
      "arn:aws:s3:::${aws_s3_bucket.ansible.id}/*"
    ]

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }
}

resource "aws_s3_bucket_policy" "ansible_secure" {
  bucket = aws_s3_bucket.ansible.id
  policy = data.aws_iam_policy_document.ansible_secure_transport.json
}
