###
# Creates all the IAM resources required for the VM to access AWS services
###

## 1- IAM Policies to be applied to instance

# required IAM policies
data "aws_iam_policy_document" "required_access" {
  statement {
    actions = [
      "ec2:DescribeTags",
      "ec2:DescribeInstances",
      "ec2:DescribeInstanceStatus",
      "cloudwatch:ListMetrics",
      "cloudwatch:GetMetricData",
      "elasticloadbalancing:DescribeLoadBalancers",
      "elasticloadbalancing:DescribeListeners",
    ]
    effect    = "Allow"
    resources = ["*"]
  }
}

resource "aws_iam_policy" "required_access" {
  name        = "${var.env}-${var.project}-vm-monitoring-required-iam"
  path        = "/"
  description = "EC2 Prometheus required policies"
  policy      = data.aws_iam_policy_document.required_access.json
}

# optional policies to check
data "aws_iam_policy_document" "optional_access" {
  count = var.optional_iam_policies != "" ? 1 : 0
  statement {
    actions = var.optional_iam_policies
    effect    = "Allow"
    resources = ["*"]
  }
}

resource "aws_iam_policy" "optional_access" {
  count = var.optional_iam_policies != "" ? 1 : 0
  name        = "${var.env}-${var.project}-vm-monitoring-optional-iam"
  path        = "/"
  description = "EC2 Prometheus optional policies"
  policy      = data.aws_iam_policy_document.optional_access[count.index].json
}

## 2- Create EC2 role to be assumed by EC2

# Assume role to allow to associate IAM policy to EC2 instance
data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

# Create IAM Role for instance
resource "aws_iam_role" "vm" {
  name               = "${var.env}-${var.project}-vm-monitoring-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
  path               = "/${var.project}/"
}

# Create instance profile
resource "aws_iam_instance_profile" "vm" {
  name = "${var.env}-${var.project}-vm-monitoring-iam-profile"
  role = aws_iam_role.vm.name
}

## 2- Attach policies to EC2 instances
resource "aws_iam_policy_attachment" "required_access" {
  name       = "${var.env}-${var.project}-vm-monitoring-required-iam"
  roles      = [aws_iam_role.vm.name]
  policy_arn = aws_iam_policy.required_access.arn
}

resource "aws_iam_policy_attachment" "optional_access" {
  count = var.optional_iam_policies != "" ? 1 : 0
  name       = "${var.env}-${var.project}-vm-monitoring-optional-iam"
  roles      = [aws_iam_role.vm.name]
  policy_arn = aws_iam_policy.optional_access[count.index].arn
}
