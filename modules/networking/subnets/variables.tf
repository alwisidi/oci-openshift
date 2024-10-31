variable "tenancy_ocid" {
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
variable "security_list_ids" {
  type = list(string)
}
variable "default_route_table_id" {
  type = string
}