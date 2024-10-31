output "oci_ccm_config" {
  value = <<OCICCMCONFIG
useInstancePrincipals: true
compartment: ${var.compartment_ocid}
vcn: ${local.vcn_cidr}
loadBalancer:
  subnet1: ${module.subnets.private_subnet_id}
  securityListManagementMode: Frontend
  securityLists:
    ${local.default_security_list_id}
rateLimiter:
  rateLimitQPSRead: 20.0
  rateLimitBucketRead: 5
  rateLimitQPSWrite: 20.0
  rateLimitBucketWrite: 5
  OCICCMCONFIG
}