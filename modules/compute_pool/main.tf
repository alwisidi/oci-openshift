resource "oci_core_instance_configuration" "compute_node_config" {
  count          = var.create_openshift_instance_pools ? 1 : 0
  compartment_id = var.compartment_ocid
  display_name   = "${var.cluster_name}-compute"
  instance_details {
    instance_type = "compute"
    launch_details {
      availability_domain = var.availability_domain
      compartment_id      = var.compartment_ocid
      create_vnic_details {
        assign_private_dns_record = "true"
        assign_public_ip          = "false"
        nsg_ids = [var.nsg_ids["compute"]]
        subnet_id = var.private_subnet_id
      }
      defined_tags = {
        "openshift-${var.cluster_name}.instance-role" = "compute"
      }
      shape = var.pool_shapes["compute"]
      shape_config {
        memory_in_gbs = var.pool_memories["compute"]
        ocpus         = var.pool_ocpus["compute"]
      }
      source_details {
        boot_volume_size_in_gbs = var.pool_boot_sizes["compute"]
        boot_volume_vpus_per_gb = var.pool_boot_volumes_vpus_per_gb["compute"]
        image_id                = var.image_id
        source_type             = "image"
      }
    }
  }
}

resource "oci_core_instance_pool" "compute_nodes" {
  count                           = var.create_openshift_instance_pools ? 1 : 0
  compartment_id                  = var.compartment_ocid
  display_name                    = "${var.cluster_name}-compute"
  instance_configuration_id       = oci_core_instance_configuration.compute_node_config[0].id
  instance_display_name_formatter = "${var.cluster_name}-compute-${var.pool_formatter_id}"
  instance_hostname_formatter     = "${var.cluster_name}-compute-${var.pool_formatter_id}"

  placement_configurations {
    availability_domain = var.availability_domain
    primary_subnet_id   = var.private_subnet_id
  }
  lifecycle {
    prevent_destroy = false
  }
  size = var.pool_replica_counts["compute"]
}