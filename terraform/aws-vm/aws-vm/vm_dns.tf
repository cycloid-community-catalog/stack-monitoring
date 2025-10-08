###
# Creates the DNS to associaye to VM (optional)
###
resource "aws_route53_record" "prometheus" {
  count   = var.create_dns && var.prometheus_install && var.use_public_ip ? 1 : 0
  zone_id = var.aws_dns_zone_id
  name    = var.prometheus_domain_name
  type    = "A"
  ttl     = 300
  records = [aws_eip.vm[0].public_ip]
}

resource "aws_route53_record" "alertmanager" {
  count   = var.create_dns && var.alertmanager_install && var.use_public_ip ? 1 : 0
  zone_id = var.aws_dns_zone_id
  name    = var.alertmanager_domain_name
  type    = "A"
  ttl     = 300
  records = [aws_eip.vm[0].public_ip]
}

resource "aws_route53_record" "grafana" {
  count   = var.create_dns && var.grafana_install && var.use_public_ip ? 1 : 0
  zone_id = var.aws_dns_zone_id
  name    = var.grafana_domain_name
  type    = "A"
  ttl     = 300
  records = [aws_eip.vm[0].public_ip]
}
