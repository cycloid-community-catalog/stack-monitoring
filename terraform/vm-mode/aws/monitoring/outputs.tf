output "machine_ip_private_address" {
  value = aws_eip.vm.private_ip
}

output "machine_ip_public_address" {
  value = aws_eip.vm.public_ip
}

output "sgs_monitoring_scraping_id" {
  value = length(data.aws_vpc.scraping) > 0 ? {for vpc_name, vpc_data in data.aws_vpc.scraping : vpc_name => aws_security_group.scraping[vpc_name].id} : {}
}

output "prometheus_domain_name" {
  value = var.prometheus_domain_name
}

output "grafana_domain_name" {
  value = var.grafana_domain_name
}

output "alertmanager_domain_name" {
  value = var.alertmanager_domain_name
}
