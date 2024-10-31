provider "oci" {
  alias  = "home"
  region = var.home_region
}

resource "oci_identity_tag_namespace" "openshift_tags" {
  compartment_id = var.compartment_ocid
  description    = "Used for track openshift related resources and policies"
  is_retired     = "false"
  name           = "openshift-${var.cluster_name}"
  provider       = oci.home
}
resource "oci_identity_tag" "openshift_instance_role" {
  description      = "Describe instance role inside OpenShift cluster"
  is_cost_tracking = "false"
  is_retired       = "false"
  name             = "instance-role"
  tag_namespace_id = oci_identity_tag_namespace.openshift_tags.id
  validator {
    validator_type = "ENUM"
    values = var.pool_types
  }
  provider = oci.home
}

resource "oci_identity_dynamic_group" "openshift_pool_nodes" {
  for_each = toset(var.pool_types)
  compartment_id = var.tenancy_ocid
  description    = "OpenShift ${each.key} nodes"
  matching_rule  = "all {instance.compartment.id='${var.compartment_ocid}', tag.openshift-${var.cluster_name}.instance-role.value='${each.key}'}"
  name           = "${var.cluster_name}_${each.key}_nodes"
  provider       = oci.home
}

resource "oci_identity_policy" "openshift_control_plane_nodes" {
  compartment_id = var.compartment_ocid
  description    = "OpenShift control_plane nodes instance principal"
  name           = "${var.cluster_name}_control_plane_nodes"
  statements = [
    "Allow dynamic-group ${oci_identity_dynamic_group.openshift_pool_nodes["control_plane"].name} to manage volume-family in compartment id ${var.compartment_ocid}",
    "Allow dynamic-group ${oci_identity_dynamic_group.openshift_pool_nodes["control_plane"].name} to manage instance-family in compartment id ${var.compartment_ocid}",
    "Allow dynamic-group ${oci_identity_dynamic_group.openshift_pool_nodes["control_plane"].name} to manage security-lists in compartment id ${var.compartment_ocid}",
    "Allow dynamic-group ${oci_identity_dynamic_group.openshift_pool_nodes["control_plane"].name} to use virtual-network-family in compartment id ${var.compartment_ocid}",
    "Allow dynamic-group ${oci_identity_dynamic_group.openshift_pool_nodes["control_plane"].name} to manage load-balancers in compartment id ${var.compartment_ocid}",
  ]
  provider = oci.home
}