###
# Creates the Network interface and security group for the VM
# to be used to deploy grafana, prometheus and alertmanager
###

resource "aws_eip" "vm" {
  instance = aws_instance.vm.id
  domain    = "vpc"
}

###
# Network Security Group - allow ingress : 80/443, 22(optionally) and 9100 (to monitor own machine)
###

resource "aws_security_group" "vm" {
  name        = "${var.organization}-vm-monitoring-sg-${var.env}"
  description = "monitoring ${var.env} for ${var.organization}"
  vpc_id      = var.vpc_id
}

# allow ALL egress
resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.vm.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}
resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv6" {
  security_group_id = aws_security_group.vm.id
  cidr_ipv6         = "::/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

# allow HTTP
resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.vm.id
  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 80
  ip_protocol = "tcp"
  to_port     = 80
}

# allow HTTPs
resource "aws_vpc_security_group_ingress_rule" "allow_https" {
  security_group_id = aws_security_group.vm.id
  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 443
  ip_protocol = "tcp"
  to_port     = 443
}

# allow SSH - to a list of CIDR and SGs
resource "aws_vpc_security_group_ingress_rule" "allow_ssh_cidr" {
  count = var.use_ssm_agent ? 0 : length(var.ssh_to_allow.cidr)

  security_group_id = aws_security_group.vm.id
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
  cidr_ipv4         = var.ssh_to_allow.cidr[count.index]
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_sgs" {
  count = var.use_ssm_agent ? 0 : length(var.ssh_to_allow.sg)

  security_group_id = aws_security_group.vm.id
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
  referenced_security_group_id = var.ssh_to_allow.sg[count.index]
}

# allow node exporter self scraping
resource "aws_vpc_security_group_ingress_rule" "allow-scraping-node-exporter" {
  security_group_id = aws_security_group.vm.id
  from_port         = "9100"
  ip_protocol          = "tcp"
  to_port           = "9100"
  referenced_security_group_id = aws_security_group.vm.id
}