###
# Creates the VM with managed disk to be used to deploy grafana, prometheus and alertmanager
###
# VM
resource "azurerm_linux_virtual_machine" "vm" {
  name                  = "${var.customer}-${var.env}-vm-monitoring"
  location              = var.location
  resource_group_name   = var.resource_group_name
  network_interface_ids = [azurerm_network_interface.vm.id]
  size                  = var.vm_size
  admin_username 		    = local.admin_username

  source_image_reference {
    publisher = var.os_image_publisher
    offer     = var.os_image_offer
    sku       = var.os_image_sku
    version   = var.os_image_version
  }

  admin_ssh_key	{
	public_key = var.keypair_public
	username = local.admin_username
  }

  os_disk {
    name                 = "${var.customer}-${var.env}-vm-monitoring-os-disk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = var.os_disk_size
  }

  tags = local.tags
}

# Managed Disk
resource "azurerm_managed_disk" "vm" {
  count                = var.install_grafana ? 1 : 0
  name                 = "${var.customer}-${var.env}-vm-monitoring-grafana-managed-disk"
  location             = var.location
  resource_group_name  = var.resource_group_name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = var.managed_disk_size

  tags = local.tags
}

resource "azurerm_virtual_machine_data_disk_attachment" "vm" {
  count              = var.install_grafana ? 1 : 0
  managed_disk_id    = azurerm_managed_disk.vm[count.index].id
  virtual_machine_id = azurerm_linux_virtual_machine.vm.id
  lun                = "10"
  caching            = "ReadWrite"
}