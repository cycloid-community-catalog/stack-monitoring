################################################################################
# S3 bucket:  creates the bucket to be used to stroe thanos data and the access key to be used to access it
################################################################################

resource "aws_s3_bucket" "thanos_data" {
  count         = var.enable_thanos ? 1 : 0
  bucket        = "${var.project}-thanos-data-${var.env}${var.project}"
  force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "thanos_data" {
  count = var.enable_thanos ? 1 : 0
  bucket   = aws_s3_bucket.thanos_data[0].id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

#
# IAM
#

# S3 deployment policy
data "aws_iam_policy_document" "thanos_data" {
  count = var.enable_thanos ? 1 : 0
  statement {
    actions = [
      "s3:GetBucketLocation",
      "s3:ListAllMyBuckets",
    ]

    effect = "Allow"

    resources = [
      "arn:aws:s3:::${aws_s3_bucket.thanos_data[0].id}/*",
    ]
  }

  statement {
    actions = [
      "s3:*",
    ]

    effect    = "Allow"
    resources = [
    "arn:aws:s3:::${aws_s3_bucket.thanos_data[0].id}/*",
    ]
  }

}

resource "aws_iam_policy" "thanos_data" {
  count       = var.enable_thanos ? 1 : 0
  name        = "${var.project}-${var.env}-s3-thanos-access"
  description = "Grant access to s3 thanos bucket"
  policy      = data.aws_iam_policy_document.thanos_data[0].json
}

resource "aws_iam_user" "thanos_data" {
  count = var.enable_thanos ? 1 : 0
  name  = "${var.project}-s3-thanos-${var.env}"
  path  = "/"
}

resource "aws_iam_access_key" "thanos_data" {
  count = var.enable_thanos ? 1 : 0
  user  = aws_iam_user.thanos_data[0].name
}

resource "aws_iam_user_policy_attachment" "thanos_data" {
  count      = var.enable_thanos ? 1 : 0
  user       = aws_iam_user.thanos_data[0].name
  policy_arn = aws_iam_policy.thanos_data[0].arn
}

