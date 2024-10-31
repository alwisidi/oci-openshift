variable "create_openshift_instance_pools" {
  type = string
}
variable "compartment_ocid" {
  type = string
}
variable "vcn_ocid" {
  type = string
}
variable "vcn_cidr" {
  type = string
}
variable "cluster_name" {
  type = string
}
variable "pool_shapes" {
  type = map(string)
}
variable "availability_domain" {
  type = string
}
variable "pool_formatter_id" {
  type = string
}
variable "pool_replica_counts" {
  type = map(string)
}
variable "pool_ocpus" {
  type = map(string)
}
variable "pool_memories" {
  type = map(string)
}
variable "pool_boot_sizes" {
  type = map(string)
}
variable "pool_boot_volumes_vpus_per_gb" {
  type = map(string)
}
variable "private_subnet_id" {
  type = string
}
variable "nsg_ids" {
  type = map(string)
}
variable "image_id" {
  type = string
}