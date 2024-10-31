data "oci_identity_tenancy" "tenancy" {
  tenancy_id = var.tenancy_ocid
}

data "oci_core_vcn" "existing_vcn" {
  vcn_id = var.vcn_ocid
}

data "oci_identity_regions" "regions" {}

data "oci_identity_availability_domain" "availability_domain" {
  compartment_id = var.compartment_ocid
  ad_number      = "1"
}

data "oci_core_compute_global_image_capability_schemas" "image_capability_schemas" {}

data "oci_core_security_lists" "existing_vcn_security_lists" {
  compartment_id = data.oci_core_vcn.existing_vcn.compartment_id
  vcn_id         = var.vcn_ocid
}

data "oci_core_vcn_dns_resolver_association" "dns_resolver_association" {
  vcn_id     = var.vcn_ocid
}

data "oci_dns_resolver" "dns_resolver" {
  resolver_id = data.oci_core_vcn_dns_resolver_association.dns_resolver_association.dns_resolver_id
  scope       = "PRIVATE"
}

# --- Subnets Data --- #
data "oci_core_route_tables" "existing_vcn_route_tables" {
  compartment_id = data.oci_core_vcn.existing_vcn.compartment_id
  vcn_id         = var.vcn_ocid
}