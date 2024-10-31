resource "oci_core_image" "openshift_image" {
  count          = var.create_openshift_instance_pools ? 1 : 0
  compartment_id = var.compartment_ocid
  display_name   = var.cluster_name
  launch_mode    = "PARAVIRTUALIZED"
  image_source_details {
    source_type = "objectStorageUri"
    source_uri  = var.openshift_image_source_uri
    source_image_type = "QCOW2"
  }
}

resource "oci_core_shape_management" "imaging_shape" {
  for_each       = var.create_openshift_instance_pools ? var.pool_shapes : {}
  compartment_id = var.compartment_ocid
  image_id       = oci_core_image.openshift_image[0].id
  shape_name     = each.value
}

resource "oci_core_compute_image_capability_schema" "openshift_image_capability_schema" {
  count                                               = var.create_openshift_instance_pools ? 1 : 0
  compartment_id                                      = var.compartment_ocid
  compute_global_image_capability_schema_version_name = var.image_schema_version
  image_id                                            = oci_core_image.openshift_image[0].id
  schema_data                                         = var.image_schema_data
}