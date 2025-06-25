###
# Creates all the IAM resources required for the VM to access AWS services
###

## 1- IAM Policies to be applied to instance

# optional policies to check
data "aws_iam_policy_document" "vm" {
  statement {
    actions = var.vm_iam_policies
    effect    = "Allow"
    resources = ["*"]
  }
}

resource "aws_iam_policy" "vm" {
  name        = "${var.organization}-vm-monitoring-iam-${var.env}"
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
  name               = "${var.organization}-vm-monitoring-role-${var.env}"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
  path               = "/${var.project}/"
}

# Create instance profile
resource "aws_iam_instance_profile" "vm" {
  name = "${var.organization}-vm-monitoring-iam-profile-${var.env}"
  role = aws_iam_role.vm.name
}

## 2- Attach policy to EC2 instances
resource "aws_iam_role_policy_attachment" "vm" {
  name       = "${var.organization}--vm-monitoring-iam-${var.env}"
  role       = aws_iam_role.vm.name
  policy_arn = aws_iam_policy.vm.arn
}

resource "aws_iam_role_policy_attachment" "ssm" {
  count      = var.use_ssm_agent ? 1 : 0
  role       = aws_iam_role.vm.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}