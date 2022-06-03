# Calculate local variables
locals {

  # Platform functions and concatenations
  platform_location_az_count  = lookup(var.platform_location_az, var.service_location, null)
  platform_fault_domain_count = lookup(var.platform_location_fault_domain, var.service_location, null)

  # Service functions and concatenations
  service_location_prefix    = replace(var.service_location, "/[a-z[:space:]]/", "")
  service_environment_prefix = substr(var.service_environment, 0, 1)

  # Resource functions and concatenations
  resource_name          = "${local.service_environment_prefix}-${local.service_location_prefix}"
  resource_instance_size = lookup(lookup(var.resource_instance_size, "Test", null), var.service_name, null)
}
