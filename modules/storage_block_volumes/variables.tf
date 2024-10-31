variable "pool_replica_counts" {
  type = map(string)
}
variable "availability_domain" {
  type = string
}
variable "compartment_ocid" {
  type = string
}
variable "cluster_name" {
  type = string
}
variable "storage_block_size" {
  type = string
}
variable "instance_data" {
  type = list(map(string))
}
