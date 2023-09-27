###
# Creates the Network interface and security group for the VM
# to be used to deploy grafana, prometheus and alertmanager
###

resource "azurerm_public_ip" "vm" {
  name                = "${var.customer}-${var.env}-vm-monitoring-ip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  tags                = local.tags
}

resource "azurerm_network_interface" "vm" {
  name                = "${var.customer}-${var.env}-vm-monitoring-pub"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "${var.customer}-${var.env}-vm-monitoring"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm.id
    primary                       = true
  }
  tags = local.tags
}

###
# Network Security Group - allow ingress : 80/443, 22(optionally) and 9100 (to monitor own machine)
###

# Create Network Security Group and rule
resource "azurerm_network_security_group" "vm" {
  name                = "${var.customer}-${var.env}-vm-monitoring-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = local.tags
}

resource "azurerm_network_interface_security_group_association" "vm" {
  network_interface_id      = azurerm_network_interface.vm.id
  network_security_group_id = azurerm_network_security_group.vm.id
}

resource "azurerm_network_security_rule" "allow-http-https" {
  name                        = "allow-http-https"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_ranges     = ["80","443"]
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.vm.name
}


resource "azurerm_network_security_rule" "allow-self-scraping" {
  name                                  = "allow-self-scraping"
  priority                              = 101
  direction                             = "Inbound"
  access                                = "Allow"
  protocol                              = "Tcp"
  source_port_range                     = "*"
  destination_port_ranges               = ["9100"]
  source_address_prefix                 = azurerm_linux_virtual_machine.vm.private_ip_address
  destination_address_prefix            = "*"
  resource_group_name                   = var.resource_group_name
  network_security_group_name           = azurerm_network_security_group.vm.name
}

resource "azurerm_network_security_rule" "allow-ssh" {
  name                          = "allow-ssh"
  priority                      = 102
  direction                     = "Inbound"
  access                        = "Allow"
  protocol                      = "Tcp"
  source_port_range             = "*"
  source_address_prefixes       = var.ssh_ips_to_allow to change
  destination_port_range        = "22"
  destination_address_prefix    = "*"
  resource_group_name           = var.resource_group_name
  network_security_group_name   = azurerm_network_security_group.vm.name
}
