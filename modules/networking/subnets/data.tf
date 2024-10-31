data "external" "available_subnets" {
  program = [
    "python3", "${path.module}/scripts/find_available_cidrs.py",
    var.vcn_cidr, var.vcn_ocid, var.tenancy_ocid
  ]
}