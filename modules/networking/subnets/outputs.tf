output "private_cidr" {
  value = data.external.available_subnets.result.private_cidr
}

output "public_cidr" {
  value = data.external.available_subnets.result.public_cidr
}

output "private_subnet_id" {
  value = oci_core_subnet.private.id
}