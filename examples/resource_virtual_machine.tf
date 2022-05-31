# Create availability set
resource "azurerm_availability_set" "availability_set" {

  # If there is less than one availability zone, create availability set
  count = local.platform_location_az_count < 1 ? 1 : 0

  # Format with leading zero
  name                        = "${local.resource_name}-as"
  location                    = module.resource_group.location
  resource_group_name         = module.resource_group.name
  platform_fault_domain_count = local.platform_fault_domain_count

  tags = {
    environment = var.service_environment
  }
}

module "virtual_machine" {
  depends_on = [
    module.network_interfaces
  ]
  source                    = "github.com/wesley-trust/tfsubmodule-virtual_machine"
  count                     = var.resource_instance_count
  name                      = "${local.resource_name}${format("%02d", count.index + 1)}-vm"
  location                  = module.resource_group.location
  resource_group_name       = module.resource_group.name
  size                      = var.resource_instance_size
  admin_username            = var.admin_username
  admin_password            = random_password.password[count.index].result
  operating_system_platform = "Windows"
  disk_size_gb              = var.resource_disk_size
  sku                       = var.resource_vm_sku
  environment               = var.service_environment

  # Select the specific network interface from the instance count
  network_interface_ids = module.network_interfaces[count.index].network_interface_ids

  # If there is less than one availability zone, then specify availability set id
  availability_set_id = local.platform_location_az_count < 1 ? azurerm_availability_set.availability_set[0].id : 0

  # If there is more than one availability zone, select the AZ in iteration from the maximum count of availability zones
  zone = local.platform_location_az_count > 1 ? (count.index % local.platform_location_az_count) + 1 : 0
}
