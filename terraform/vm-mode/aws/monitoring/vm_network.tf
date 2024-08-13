###
# Creates the Network interface and security group for the VM
# to be used to deploy grafana, prometheus and alertmanager
###

resource "aws_eip" "vm" {
  instance = aws_instance.vm.id
  domain    = "vpc"
  tags = local.tags
}

###
# Network Security Group - allow ingress : 80/443, 22(optionally) and 9100 (to monitor own machine)
###

resource "aws_security_group" "vm" {
  name        = "${var.customer}-${var.env}-vm-monitoring-sg"
  description = "monitoring ${var.env} for ${var.project}"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = local.tags
}

resource "aws_security_group_rule" "allow_http" {
  type              = "ingress"
  from_port         = "80"
  to_port           = "80"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.vm.id
}

resource "aws_security_group_rule" "allow_https" {
  type              = "ingress"
  from_port         = "443"
  to_port           = "443"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.vm.id
}

resource "aws_security_group_rule" "allow-ssh-bastion" {
  count                    = var.bastion_sg_allow != "" ? 1 : 0
  type                     = "ingress"
  from_port                = "22"
  to_port                  = "22"
  protocol                 = "tcp"
  source_security_group_id = var.bastion_sg_allow
  security_group_id        = aws_security_group.vm.id
}

resource "aws_security_group_rule" "allow-ssh" {
  count                    = var.ssh_ips_to_allow != [] ? 1 : 0
  type                     = "ingress"
  from_port                = "22"
  to_port                  = "22"
  protocol                 = "tcp"
  cidr_blocks              = var.ssh_ips_to_allow
  security_group_id        = aws_security_group.vm.id
}

resource "aws_security_group_rule" "allow-self-scraping" {
  type              = "ingress"
  from_port         = "9100"
  to_port           = "9100"
  protocol          = "tcp"
  self              = true
  security_group_id = aws_security_group.vm.id
}
