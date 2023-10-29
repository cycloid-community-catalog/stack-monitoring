###
# Creates the security group to be used by other VMs to allow scraping in ports
# to be used to deploy grafana, prometheus and alertmanager 9100 + others if needed
###

resource "aws_security_group" "scraping" {
  for_each = length(var.vpcs_to_scrape) > 0 ? var.vpcs_to_scrape : []
  name        = "${var.customer}-${var.env}-vm-monitoring-scraping"
  description = "Allow metrics server to collect metrics"
  vpc_id      = each.key

  ingress {
    from_port       = 9100
    to_port         = 9100
    protocol        = "tcp"
    security_groups = [aws_security_group.vm.id]
    self            = false
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.tags
}