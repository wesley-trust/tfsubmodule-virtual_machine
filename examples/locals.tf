# Calculate local variables
locals {

  # Platform functions and concatenations
  platform_location_az_count  = lookup(var.platform_location_az, var.service_location, null)
  platform_fault_domain_count = lookup(var.platform_location_fault_domain, var.service_location, null)

  # Service functions and concatenations
  service_location_prefix    = replace(var.service_location, "/[a-z[:space:]]/", "")
  service_environment_prefix = substr(var.service_environment, 0, 1)

  # Resource functions and concatenations
  resource_group_name    = "${var.service_name}-${var.service_environment}-${local.service_location_prefix}-${var.service_deployment}-rg"
  resource_name          = "${local.service_environment_prefix}-${local.service_location_prefix}-${var.resource_name}"
  resource_instance_size = lookup(lookup(var.resource_instance_size, "Test", null), var.service_name, null)
}
