output "id" {
  value = azurerm_windows_virtual_machine.virtual_machine[0].id != null ? azurerm_windows_virtual_machine.virtual_machine[0].id : azurerm_linux_virtual_machine.virtual_machine[0].id
}
