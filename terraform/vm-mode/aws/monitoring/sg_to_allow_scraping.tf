###
# Creates the security group to be used by other VMs to allow scraping in ports
# to be used to deploy grafana, prometheus and alertmanager 9100 + others if needed
###

# to get the vpc_name
data "aws_vpc" "scraping" {
  for_each = length(var.vpcs_to_scrape) > 0 ? toset(var.vpcs_to_scrape) : []

  id = each.key
}


resource "aws_security_group" "scraping" {
  for_each = length(var.vpcs_to_scrape) > 0 ? data.aws_vpc.scraping : []
  name        = "${var.customer}-${var.env}-vm-monitoring-scraping-vpc-${each.value.tags.Name}"
  description = "Allow metrics server to collect metrics"
  vpc_id      = each.value.id

  ingress {
    from_port       = 9100
    to_port         = 9100
    protocol        = "tcp"
    security_groups = [aws_security_group.vm.id]
    self            = false
  }

  dynamic "ingress" {
    for_each = var.prometheus_ports

    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol        = "tcp"
      security_groups = [aws_security_group.vm.id]
      self            = false
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.tags
}