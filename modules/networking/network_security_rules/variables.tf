variable "compartment_ocid" {
  type = string
}
variable "vcn_ocid" {
  type = string
}
variable "all_traffic" {
  type = string
}
variable "all_protocols" {
  type = string
}
variable "vcn_cidr" {
  type = string
}
variable "pool_types" {
  type = list(string)
}