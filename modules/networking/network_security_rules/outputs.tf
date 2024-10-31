output "nsg_ids" {
  value = merge(
    {
      cluster_lb_nsg = oci_core_network_security_group.cluster_lb_nsg.id
    },
    {
      for pool_type, nsg in oci_core_network_security_group.cluster_nsg : pool_type => nsg.id
    }
  )
}