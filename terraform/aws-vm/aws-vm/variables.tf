# Cycloid variables
variable "organization" {}
variable "project" {}
variable "env" {}

# vm configuration variables
variable "vm_size" {}
variable "os_disk_size" {}
variable "os_disk_type" {
  default = "gp3"
}
variable "vm_iam_policies" {
  default = [
    "ec2:DescribeTags",
    "ec2:DescribeInstances",
    "ec2:DescribeInstanceStatus",
    "cloudwatch:ListMetrics",
    "cloudwatch:GetMetricData",
  ]
}

# vm network variables
variable "subnet_id" {}
variable "vpc_id" {}
variable "ssh_to_allow" {
  type = map(list(string))

  default = {
    cidr = ["0.0.0.0/0"]
    sgs = []
  }
}
variable "use_bastion" {
  default = false
}
variable "use_ssm_agent"{
  default = true
}
variable "bastion_public_ssh_key" {
  default = ""
}

# ssl
variable "tls_crt" {
  default = ""
}

variable "tls_key" {
  default = ""
}
variable "enable_tls" {
  default = false
}

variable "create_self_signed_certificate" {
  default = true
}

# vm dns variables
variable "create_dns" {
  default = false
}
variable "aws_dns_zone_id" {
  default = ""
}

# tools to install
variable "prometheus_install" {}
variable "prometheus_domain_name" {
  default = "prometheus.local"
}

variable "alertmanager_install" {}
variable "alertmanager_domain_name" {
  default = "alertmanager.local"
}

variable "grafana_install" {}
variable "grafana_domain_name" {
  default = "grafana.local"
}

# required for cloudwatch recovery
variable "aws_region" {}

locals{
  username = var.organization
}