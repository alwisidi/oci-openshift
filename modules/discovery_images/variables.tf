variable "create_openshift_instance_pools" {
  type = string
}
variable "compartment_ocid" {
  type = string
}
variable "cluster_name" {
  type = string
}
variable "openshift_image_source_uri" {
  type = string
}
variable "pool_shapes" {
  type = map(string)
}
variable "image_schema_version" {
  type = string
}
variable "image_schema_data" {
  type = map(string)
}