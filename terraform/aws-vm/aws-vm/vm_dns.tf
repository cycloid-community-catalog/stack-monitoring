###
# Creates the DNS to associaye to VM (optional)
###
resource "aws_route53_record" "prometheus" {
  count   = var.create_dns && var.prometheus_install ? 1 : 0
  zone_id = var.aws_dns_zone_id
  name    = var.prometheus_domain_name
  type    = "A"
  ttl     = 300
  records = [try(aws_eip.vm[0].private_ip, aws_instance.vm.private_ip)]
}

resource "aws_route53_record" "alertmanager" {
  count   = var.create_dns && var.alertmanager_install ? 1 : 0
  zone_id = var.aws_dns_zone_id
  name    = var.alertmanager_domain_name
  type    = "A"
  ttl     = 300
  records = [try(aws_eip.vm[0].private_ip, aws_instance.vm.private_ip)]
}

resource "aws_route53_record" "grafana" {
  count   = var.create_dns && var.grafana_install ? 1 : 0
  zone_id = var.aws_dns_zone_id
  name    = var.grafana_domain_name
  type    = "A"
  ttl     = 300
  records = [try(aws_eip.vm[0].private_ip, aws_instance.vm.private_ip)]
}
