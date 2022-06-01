# Select output ID for VM
locals {
  id = try(
    azurerm_windows_virtual_machine.virtual_machine[0].id,
    azurerm_linux_virtual_machine.virtual_machine[0].id
  )
}
