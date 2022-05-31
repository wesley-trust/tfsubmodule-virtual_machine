# Create virtual machine
resource "azurerm_windows_virtual_machine" "virtual_machine" {
  count = var.operating_system_platform == "Windows" ? 1 : 0

  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  size                = var.size
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  license_type        = "Windows_Server"

  # Specify list of network IDs
  network_interface_ids = var.network_interface_ids

  # Specify the availability set (if not null)
  availability_set_id = var.availability_set_id

  # Specify the availability zone (if not null) 
  zone = var.zone

  os_disk {
    caching              = "ReadOnly"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = var.disk_size_gb
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = var.sku
    version   = "latest"
  }

  boot_diagnostics {
    storage_account_uri = null
  }

  tags = {
    environment = var.environment
  }

}
