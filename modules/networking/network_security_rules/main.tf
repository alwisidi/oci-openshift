resource "oci_core_network_security_group" "cluster_lb_nsg" {
  compartment_id = var.compartment_ocid
  vcn_id         = var.vcn_ocid
  display_name   = "cluster-lb-nsg"
}

resource "oci_core_network_security_group_security_rule" "cluster_lb_nsg_rule_1" {
  network_security_group_id = oci_core_network_security_group.cluster_lb_nsg.id
  direction                 = "EGRESS"
  destination               = var.all_traffic
  protocol                  = var.all_protocols
}

resource "oci_core_network_security_group_security_rule" "cluster_lb_nsg_rule_2" {
  network_security_group_id = oci_core_network_security_group.cluster_lb_nsg.id
  protocol                  = "6"
  direction                 = "INGRESS"
  source                    = var.all_traffic
  tcp_options {
    destination_port_range {
      min = 6443
      max = 6443
    }
  }
}

resource "oci_core_network_security_group_security_rule" "cluster_lb_nsg_rule_3" {
  network_security_group_id = oci_core_network_security_group.cluster_lb_nsg.id
  protocol                  = "6"
  direction                 = "INGRESS"
  source                    = var.all_traffic
  tcp_options {
    destination_port_range {
      min = 80
      max = 80
    }
  }
}

resource "oci_core_network_security_group_security_rule" "cluster_lb_nsg_rule_4" {
  network_security_group_id = oci_core_network_security_group.cluster_lb_nsg.id
  protocol                  = "6"
  direction                 = "INGRESS"
  source                    = var.all_traffic
  tcp_options {
    destination_port_range {
      min = 443
      max = 443
    }
  }
}

resource "oci_core_network_security_group_security_rule" "cluster_lb_nsg_rule_5" {
  network_security_group_id = oci_core_network_security_group.cluster_lb_nsg.id
  protocol                  = var.all_protocols
  direction                 = "INGRESS"
  source                    = var.vcn_cidr
}

resource "oci_core_network_security_group" "cluster_nsg" {
  for_each      = toset(var.pool_types)
  compartment_id = var.compartment_ocid
  vcn_id         = var.vcn_ocid
  display_name   = "cluster-${each.key}-nsg"
}

resource "oci_core_network_security_group_security_rule" "egress_rule" {
  for_each = toset(var.pool_types)
  network_security_group_id = oci_core_network_security_group.cluster_nsg[each.key].id
  direction                 = "EGRESS"
  destination               = var.all_traffic
  protocol                  = var.all_protocols
}

resource "oci_core_network_security_group_security_rule" "ingress_rule" {
  for_each = toset(var.pool_types)
  network_security_group_id = oci_core_network_security_group.cluster_nsg[each.key].id
  protocol                  = var.all_protocols
  direction                 = "INGRESS"
  source                    = var.vcn_cidr
}
