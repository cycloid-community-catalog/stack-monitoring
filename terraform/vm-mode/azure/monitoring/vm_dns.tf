###
# Creates the DNS to associaye to VM (optional)
###
resource "azurerm_dns_a_record" "prometheus" {
  count               = var.create_dns && install_prometheus ? 1 : 0
  name                = var.prometheus_domain_name
  resource_group_name = var.resource_group_name
  zone_name           = var.azure_dns_zone_name
  ttl                 = 300
  records             = [azurerm_network_interface.vm.private_ip_address]
}

resource "azurerm_dns_a_record" "alertmanager" {
  count               = var.create_dns && install_alertmanager ? 1 : 0
  name                = var.alertmanager_domain_name
  resource_group_name = var.resource_group_name
  zone_name           = var.azure_dns_zone_name
  ttl                 = 300
  records             = [azurerm_network_interface.vm.private_ip_address]
}

resource "azurerm_dns_a_record" "grafana" {
  count               = var.create_dns && install_grafana ? 1 : 0
  name                = var.grafana_domain_name
  resource_group_name = var.resource_group_name
  zone_name           = var.azure_dns_zone_name
  ttl                 = 300
  records             = [azurerm_network_interface.vm.private_ip_address]
}