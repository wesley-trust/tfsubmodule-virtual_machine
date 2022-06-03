# Create network interfaces
module "network_interfaces" {

  # Force explicit dependency to prevent race condition/deadlock in network module
  depends_on = [
    module.service_network
  ]

  count                               = var.resource_instance_count
  source                              = "github.com/wesley-trust/tfsubmodule-network_interfaces"
  resource_location                   = module.resource_group.location
  resource_group_name                 = module.resource_group.name
  resource_environment                = var.service_environment
  resource_name                       = "${local.resource_name}${format("%02d", count.index + 1)}-vm"
  resource_network_interface_count    = var.resource_network_interface_count
  resource_subnet_id                  = module.service_network.subnet_id
  resource_subnet_address_prefixes    = module.service_network.subnet_address_prefixes
  resource_private_ip_initial_address = var.resource_private_ip_initial_address + count.index
}

module "service_network" {
  source                        = "github.com/wesley-trust/tfsubmodule-network"
  service_name                  = var.service_name
  service_location_prefix       = local.service_location_prefix
  resource_location             = module.resource_group.location
  resource_group_name           = module.resource_group.name
  resource_environment          = var.service_environment
  resource_address_space        = var.resource_address_space
  resource_dns_servers          = var.resource_dns_servers
  resource_network_subnet_count = var.resource_network_interface_count
  resource_network_role         = var.resource_network_role
}
