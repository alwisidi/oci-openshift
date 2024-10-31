data "external" "get_instance_ids" {
  program = ["sh", "${path.module}/scripts/get_instance_ids.sh", var.compartment_ocid, var.cluster_name]

  depends_on = [oci_core_instance_pool.storage_nodes]
}