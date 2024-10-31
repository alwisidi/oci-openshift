resource "oci_core_instance_configuration" "control_plane_node_config" {
  count          = var.create_openshift_instance_pools ? 1 : 0
  compartment_id = var.compartment_ocid
  display_name   = "${var.cluster_name}-control_plane"
  instance_details {
    instance_type = "compute"
    launch_details {
      availability_domain = var.availability_domain
      compartment_id      = var.compartment_ocid
      create_vnic_details {
        assign_private_dns_record = "true"
        assign_public_ip          = "false"
        nsg_ids = [var.nsg_ids["control_plane"]]
        subnet_id = var.private_subnet_id
      }
      defined_tags = {
        "openshift-${var.cluster_name}.instance-role" = "control_plane"
      }
      shape = var.pool_shapes["control_plane"]
      shape_config {
        memory_in_gbs = var.pool_memories["control_plane"]
        ocpus         = var.pool_ocpus["control_plane"]
      }
      source_details {
        boot_volume_size_in_gbs = var.pool_boot_sizes["control_plane"]
        boot_volume_vpus_per_gb = var.pool_boot_volumes_vpus_per_gb["control_plane"]
        image_id                = var.image_id
        source_type             = "image"
      }
    }
  }
}

resource "oci_core_instance_pool" "control_plane_nodes" {
  count                           = var.create_openshift_instance_pools ? 1 : 0
  compartment_id                  = var.compartment_ocid
  display_name                    = "${var.cluster_name}-control-plane"
  instance_configuration_id       = oci_core_instance_configuration.control_plane_node_config[0].id
  instance_display_name_formatter = "${var.cluster_name}-control-plane-${var.pool_formatter_id}"
  instance_hostname_formatter     = "${var.cluster_name}-control-plane-${var.pool_formatter_id}"

  load_balancers {
    backend_set_name = var.api_backend_name
    load_balancer_id = var.api_lb_id
    port             = "6443"
    vnic_selection   = "PrimaryVnic"
  }
  load_balancers {
    backend_set_name = var.api_mcs_ignition_backend_name
    load_balancer_id = var.api_lb_id
    port             = "22623"
    vnic_selection   = "PrimaryVnic"
  }
  load_balancers {
    backend_set_name = var.api_mcs_update_backend
    load_balancer_id = var.api_lb_id
    port             = "22624"
    vnic_selection   = "PrimaryVnic"
  }
  placement_configurations {
    availability_domain = var.availability_domain
    primary_subnet_id   = var.private_subnet_id
  }
  lifecycle {
    prevent_destroy = false
  }
  size = var.pool_replica_counts["control_plane"]
}