locals {
  vcn_cidr = data.oci_core_vcn.existing_vcn.cidr_block

  pool_types = [
    "control_plane",
    "infra",
    "storage",
    "compute",
  ]
  pool_shapes = {
    control_plane = var.control_plane_shape
    infra         = var.infra_shape
    storage       = var.storage_shape
    compute       = var.compute_shape
  }
  pool_replica_counts = {
    control_plane = var.control_plane_replica_count
    infra         = var.infra_replica_count
    storage       = var.storage_replica_count
    compute       = var.compute_replica_count
  }
  pool_ocpus = {
    control_plane = var.control_plane_ocpu
    infra         = var.infra_ocpu
    storage       = var.storage_ocpu
    compute       = var.compute_ocpu
  }
  pool_memories = {
    control_plane = var.control_plane_memory
    infra         = var.infra_memory
    storage       = var.storage_memory
    compute       = var.compute_memory
  }
  pool_boot_sizes = {
    control_plane = var.control_plane_boot_size
    infra         = var.infra_boot_size
    storage       = var.storage_boot_size
    compute       = var.compute_boot_size
  }
  pool_boot_volumes_vpus_per_gb = {
    control_plane = var.control_plane_boot_volume_vpus_per_gb
    infra         = var.infra_boot_volume_vpus_per_gb
    storage       = var.storage_boot_volume_vpus_per_gb
    compute       = var.compute_boot_volume_vpus_per_gb
  }

  all_protocols                   = "all"
  anywhere                        = "0.0.0.0/0"
  create_openshift_instance_pools = true
  pool_formatter_id               = join("", ["$", "{launchCount}"])

  global_image_capability_schemas = data.oci_core_compute_global_image_capability_schemas.image_capability_schemas.compute_global_image_capability_schemas
  image_schema_data = {
    "Compute.Firmware" = "{\"values\": [\"UEFI_64\"],\"defaultValue\": \"UEFI_64\",\"descriptorType\": \"enumstring\",\"source\": \"IMAGE\"}"
  }

  default_security_list_id = element(
    [
      for sl in data.oci_core_security_lists.existing_vcn_security_lists.security_lists : sl.id
      if sl.display_name == "DataSecurityList" || length(regexall("Default Security List for", sl.display_name)) > 0
    ],
    0
  )

  # --- Federation Locals --- #
  region_map = {
    for r in data.oci_identity_regions.regions.regions :
    r.key => r.name
  }
  home_region = local.region_map[data.oci_identity_tenancy.tenancy.home_region_key]

  # --- Subnets Locals --- #
  default_route_table_id = element(
    [
      for rt in data.oci_core_route_tables.existing_vcn_route_tables.route_tables : rt.id
      if rt.display_name == "PrivateRouteTable" || length(regexall("Default Route Table for", rt.display_name)) > 0
    ],
    0
  )
}