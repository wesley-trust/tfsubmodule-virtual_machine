output "virtual_machine_id" {
  value = module.virtual_machine[*].id
}

output "resource_group_name" {
  value = module.resource_group.name
}

output "network_name" {
  value = module.service_network.network_name
}