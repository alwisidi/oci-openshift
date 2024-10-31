resource "random_id" "dns_suffix" {
  byte_length = 2
}

resource "oci_core_subnet" "private" {
  cidr_block                 = data.external.available_subnets.result.private_cidr
  display_name               = "${var.cluster_name}-private_subnet"
  compartment_id             = var.compartment_ocid
  vcn_id                     = var.vcn_ocid
  route_table_id             = var.default_route_table_id
  security_list_ids          = var.security_list_ids
  dns_label                  = substr("pvtopenshift${random_id.dns_suffix.hex}", 0, 15)
  prohibit_public_ip_on_vnic = true
}

# resource "oci_core_subnet" "public" {
#   cidr_block                 = data.external.available_subnets.result.public_cidr
#   display_name               = "${var.cluster_name}-public_subnet"
#   compartment_id             = var.compartment_ocid
#   vcn_id                     = var.vcn_ocid
#   route_table_id             = var.default_route_table_id
#   security_list_ids          = var.security_list_ids
#   dns_label                  = substr("pubopenshift${random_id.dns_suffix.hex}", 0, 15)
#   prohibit_public_ip_on_vnic = true
# }