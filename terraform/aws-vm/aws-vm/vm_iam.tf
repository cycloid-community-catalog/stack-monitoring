###
# Creates all the IAM resources required for the VM to access AWS services
###

## 1- IAM Policies to be applied to instance

# optional policies to check
data "aws_iam_policy_document" "vm" {
  statement {
    actions   = var.vm_iam_policies
    effect    = "Allow"
    resources = ["*"]
  }
}

resource "aws_iam_policy" "vm" {
  name        = local.name_prefix
  path        = "/"
  description = "EC2 Prometheus IAM policies"
  policy      = data.aws_iam_policy_document.vm.json
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
  name               = local.name_prefix
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
  path               = "/${var.project}/"
}

# Create instance profile
resource "aws_iam_instance_profile" "vm" {
  name = local.name_prefix
  role = aws_iam_role.vm.name
}

## 2- Attach policy to EC2 instances
resource "aws_iam_role_policy_attachment" "vm" {
  role       = aws_iam_role.vm.name
  policy_arn = aws_iam_policy.vm.arn
}

resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.vm.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}