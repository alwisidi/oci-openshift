resource "oci_dns_rrset" "openshift_api" {
  domain = "api.${var.cluster_name}.${var.zone_dns}"
  items {
    domain = "api.${var.cluster_name}.${var.zone_dns}"
    rdata  = var.open_shift_api_lb_address
    rtype  = "A"
    ttl    = "3600"
  }
  rtype           = "A"
  zone_name_or_id = var.dns_zone_ocid
}

resource "oci_dns_rrset" "openshift_api_int" {
  domain = "api-int.${var.cluster_name}.${var.zone_dns}"
  items {
    domain = "api-int.${var.cluster_name}.${var.zone_dns}"
    rdata  = var.open_shift_api_lb_address
    rtype  = "A"
    ttl    = "3600"
  }
  rtype           = "A"
  zone_name_or_id = var.dns_zone_ocid
}

resource "oci_dns_rrset" "openshift_apps" {
  domain = "*.apps.${var.cluster_name}.${var.zone_dns}"
  items {
    domain = "*.apps.${var.cluster_name}.${var.zone_dns}"
    rdata  = var.open_shift_apps_lb_address
    rtype  = "A"
    ttl    = "3600"
  }
  rtype           = "A"
  zone_name_or_id = var.dns_zone_ocid
}