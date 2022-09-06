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

    dynamic "diff_disk_settings" {
      for_each = var.ephemeral_disk_enabled == true ? [1] : []
      content {
        option    = "Local"
        placement = "CacheDisk"
      }
    }
  }

  # Specify a custom image (if not null)
  source_image_id = var.source_image_id

  # Use a standard image if a custom image is not provided
  dynamic "source_image_reference" {
    for_each = var.source_image_id == null ? [1] : []

    content {
      publisher = "MicrosoftWindowsServer"
      offer     = "WindowsServer"
      sku       = var.sku
      version   = "latest"
    }
  }

  boot_diagnostics {
    storage_account_uri = null
  }

  tags = {
    environment = var.environment
  }

}
