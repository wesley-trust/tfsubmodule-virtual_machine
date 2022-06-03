module "virtual_machine" {
  depends_on = [
    module.network_interfaces
  ]
  source                    = "../"
  count                     = var.resource_instance_count
  name                      = "${local.resource_name}${format("%02d", count.index + 1)}-vm"
  location                  = module.resource_group.location
  resource_group_name       = module.resource_group.name
  size                      = local.resource_instance_size
  admin_username            = var.admin_username
  admin_password            = random_password.password[count.index].result
  operating_system_platform = var.operating_system_platform
  disk_size_gb              = var.resource_disk_size
  sku                       = var.resource_vm_sku
  environment               = var.service_environment

  # Select the specific network interface from the instance count
  network_interface_ids = module.network_interfaces[count.index].network_interface_ids

  # Set null values
  availability_set_id = null
  zone                = null
}
