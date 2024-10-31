variable "compartment_ocid" {
  type = string
}
variable "cluster_name" {
  type = string
}
variable "private_subnet_id" {
  type = string
}
variable "nsg_ids" {
  type = map(string)
}
variable "load_balancer_shape_details_maximum_bandwidth_in_mbps" {
  type = string
}
variable "load_balancer_shape_details_minimum_bandwidth_in_mbps" {
  type = string
}