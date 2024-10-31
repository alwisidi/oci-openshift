output "image_id" {
  value = oci_core_image.openshift_image[0].id
}