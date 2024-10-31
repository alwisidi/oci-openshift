resource "oci_core_volume" "storage_volume" {
  count               = var.pool_replica_counts["storage"]
  availability_domain = var.availability_domain
  compartment_id      = var.compartment_ocid
  display_name        = "${var.cluster_name}-storage-volume-${count.index + 1}"
  size_in_gbs         = var.storage_block_size
}

resource "oci_core_volume_attachment" "storage_volume_attachment" {
  for_each = {
    for idx, vol in oci_core_volume.storage_volume :
    tostring(idx) => vol
  }
  instance_id = var.instance_data[
    index(
      [for instance in var.instance_data : regex("[0-9]+$", instance.instance_name)],
      regex("[0-9]+$", each.value.display_name)
    )
  ].id
  volume_id = each.value.id
  attachment_type = "paravirtualized"
  lifecycle {
    ignore_changes = [
      instance_id,
      volume_id,
    ]
  }
  depends_on = [oci_core_volume.storage_volume]
}