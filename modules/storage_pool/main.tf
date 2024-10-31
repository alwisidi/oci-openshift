resource "oci_core_instance_configuration" "storage_node_config" {
  count          = var.create_openshift_instance_pools ? 1 : 0
  compartment_id = var.compartment_ocid
  display_name   = "${var.cluster_name}-storage"
  instance_details {
    instance_type = "compute"
    launch_details {
      availability_domain = var.availability_domain
      compartment_id      = var.compartment_ocid
      create_vnic_details {
        assign_private_dns_record = "true"
        assign_public_ip          = "false"
        nsg_ids = [var.nsg_ids["storage"]]
        subnet_id = var.private_subnet_id
      }
      defined_tags = {
        "openshift-${var.cluster_name}.instance-role" = "storage"
      }
      shape = var.pool_shapes["storage"]
      shape_config {
        memory_in_gbs = var.pool_memories["storage"]
        ocpus         = var.pool_ocpus["storage"]
      }
      source_details {
        boot_volume_size_in_gbs = var.pool_boot_sizes["storage"]
        boot_volume_vpus_per_gb = var.pool_boot_volumes_vpus_per_gb["storage"]
        image_id                = var.image_id
        source_type             = "image"
      }
    }
  }
}
resource "oci_core_instance_pool" "storage_nodes" {
  count                           = var.create_openshift_instance_pools ? 1 : 0
  compartment_id                  = var.compartment_ocid
  display_name                    = "${var.cluster_name}-storage"
  instance_configuration_id       = oci_core_instance_configuration.storage_node_config[0].id
  instance_display_name_formatter = "${var.cluster_name}-storage-${var.pool_formatter_id}"
  instance_hostname_formatter     = "${var.cluster_name}-storage-${var.pool_formatter_id}"
  placement_configurations {
    availability_domain = var.availability_domain
    primary_subnet_id   = var.private_subnet_id
  }
  lifecycle {
    prevent_destroy = false
  }
  size = var.pool_replica_counts["storage"]
}