###
# Creates the security group to be used by other VMs to allow scraping in ports
# to be used to deploy grafana, prometheus and alertmanager 9100 + others if needed
###
resource "azurerm_network_security_group" "scraping" {
  name                = "${var.customer}-vm-monitoring-scraping"
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = local.tags
}

resource "azurerm_network_security_rule" "scraping" {
  name                        			    = "allow-metrics-scraping"
  priority                    			    = 500
  direction                   			    = "Inbound"
  access                      			    = "Allow"
  protocol                    			    = "Tcp"
  source_port_range           			    = "9100"
  destination_port_ranges     			    = ["9100"]
  source_address_prefix                 = azurerm_linux_virtual_machine.vm.private_ip_address
  destination_address_prefix  			    = "*"
  resource_group_name         			    = var.resource_group_name
  network_security_group_name 			    = azurerm_network_security_group.scraping.name
}
