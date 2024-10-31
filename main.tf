terraform {
  required_version = ">= 1.0"
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = ">= 5.45.0"
    }
    time = {
      source  = "hashicorp/time"
      version = ">= 0.11.1"
    }
  }
}

provider "oci" {
  region = var.region
}

module "federation" {
  source = "./modules/federation"

  compartment_ocid = var.compartment_ocid
  cluster_name     = var.cluster_name
  pool_types       = local.pool_types
  tenancy_ocid     = var.tenancy_ocid
  home_region      = local.home_region
}

module "discovery_images" {
  source = "./modules/discovery_images"

  create_openshift_instance_pools = local.create_openshift_instance_pools
  compartment_ocid                = var.compartment_ocid
  cluster_name                    = var.cluster_name
  openshift_image_source_uri      = var.openshift_image_source_uri
  pool_shapes                     = local.pool_shapes
  image_schema_version            = local.global_image_capability_schemas[0].current_version_name
  image_schema_data               = local.image_schema_data
}

module "subnets" {
  source = "./modules/networking/subnets"

  tenancy_ocid           = var.tenancy_ocid
  compartment_ocid       = var.compartment_ocid
  vcn_ocid               = var.vcn_ocid
  vcn_cidr               = local.vcn_cidr
  cluster_name           = var.cluster_name
  security_list_ids      = [local.default_security_list_id]
  default_route_table_id = local.default_route_table_id
}

module "network_security_rules" {
  source = "./modules/networking/network_security_rules"

  compartment_ocid = var.compartment_ocid
  vcn_ocid         = var.vcn_ocid
  all_traffic      = local.anywhere
  all_protocols    = local.all_protocols
  vcn_cidr         = local.vcn_cidr
  pool_types       = local.pool_types
}

module "load_balancers" {
  source = "./modules/networking/load_balancers"

  compartment_ocid                                      = var.compartment_ocid
  cluster_name                                          = var.cluster_name
  private_subnet_id                                     = module.subnets.private_subnet_id
  nsg_ids                                               = module.network_security_rules.nsg_ids
  load_balancer_shape_details_maximum_bandwidth_in_mbps = var.load_balancer_shape_details_maximum_bandwidth_in_mbps
  load_balancer_shape_details_minimum_bandwidth_in_mbps = var.load_balancer_shape_details_minimum_bandwidth_in_mbps
}

module "dns_records" {
  source = "./modules/networking/dns_records"

  cluster_name               = var.cluster_name
  zone_dns                   = var.zone_dns
  dns_zone_ocid              = var.dns_zone_ocid
  open_shift_api_lb_address  = module.load_balancers.open_shift_api_lb_address
  open_shift_apps_lb_address = module.load_balancers.open_shift_apps_lb_address
}

module "control_plane_pool" {
  source = "./modules/control_plane_pool"

  create_openshift_instance_pools = local.create_openshift_instance_pools
  compartment_ocid                = var.compartment_ocid
  vcn_ocid                        = var.vcn_ocid
  vcn_cidr                        = local.vcn_cidr
  cluster_name                    = var.cluster_name
  pool_shapes                     = local.pool_shapes
  availability_domain             = data.oci_identity_availability_domain.availability_domain.name
  pool_formatter_id               = local.pool_formatter_id
  pool_replica_counts             = local.pool_replica_counts
  pool_ocpus                      = local.pool_ocpus
  pool_memories                   = local.pool_memories
  pool_boot_sizes                 = local.pool_boot_sizes
  pool_boot_volumes_vpus_per_gb   = local.pool_boot_volumes_vpus_per_gb
  private_subnet_id               = module.subnets.private_subnet_id
  nsg_ids                         = module.network_security_rules.nsg_ids
  image_id                        = module.discovery_images.image_id
  api_lb_id                       = module.load_balancers.api_lb_id
  api_backend_name                = module.load_balancers.api_backend_name
  api_mcs_ignition_backend_name   = module.load_balancers.api_mcs_ignition_backend_name
  api_mcs_update_backend          = module.load_balancers.api_mcs_update_backend
}

module "infra_pool" {
  source = "./modules/infra_pool"

  create_openshift_instance_pools = local.create_openshift_instance_pools
  compartment_ocid                = var.compartment_ocid
  vcn_ocid                        = var.vcn_ocid
  vcn_cidr                        = local.vcn_cidr
  cluster_name                    = var.cluster_name
  pool_shapes                     = local.pool_shapes
  availability_domain             = data.oci_identity_availability_domain.availability_domain.name
  pool_formatter_id               = local.pool_formatter_id
  pool_replica_counts             = local.pool_replica_counts
  pool_ocpus                      = local.pool_ocpus
  pool_memories                   = local.pool_memories
  pool_boot_sizes                 = local.pool_boot_sizes
  pool_boot_volumes_vpus_per_gb   = local.pool_boot_volumes_vpus_per_gb
  private_subnet_id               = module.subnets.private_subnet_id
  nsg_ids                         = module.network_security_rules.nsg_ids
  image_id                        = module.discovery_images.image_id
  apps_lb_id                      = module.load_balancers.apps_lb_id
  ingress_https_backend_name      = module.load_balancers.ingress_https_backend_name
  ingress_http_backend_name       = module.load_balancers.ingress_http_backend_name
}

module "storage_pool" {
  source = "./modules/storage_pool"

  create_openshift_instance_pools = local.create_openshift_instance_pools
  compartment_ocid                = var.compartment_ocid
  vcn_ocid                        = var.vcn_ocid
  vcn_cidr                        = local.vcn_cidr
  cluster_name                    = var.cluster_name
  pool_shapes                     = local.pool_shapes
  availability_domain             = data.oci_identity_availability_domain.availability_domain.name
  pool_formatter_id               = local.pool_formatter_id
  pool_replica_counts             = local.pool_replica_counts
  pool_ocpus                      = local.pool_ocpus
  pool_memories                   = local.pool_memories
  pool_boot_sizes                 = local.pool_boot_sizes
  pool_boot_volumes_vpus_per_gb   = local.pool_boot_volumes_vpus_per_gb
  private_subnet_id               = module.subnets.private_subnet_id
  nsg_ids                         = module.network_security_rules.nsg_ids
  image_id                        = module.discovery_images.image_id
}

module "storage_block_volumes" {
  source = "./modules/storage_block_volumes"

  pool_replica_counts             = local.pool_replica_counts
  availability_domain             = data.oci_identity_availability_domain.availability_domain.name
  compartment_ocid                = var.compartment_ocid
  cluster_name                    = var.cluster_name
  storage_block_size              = var.storage_block_size
  instance_data                   = module.storage_pool.instance_data
}

module "compute_pool" {
  source = "./modules/compute_pool"

  create_openshift_instance_pools = local.create_openshift_instance_pools
  compartment_ocid                = var.compartment_ocid
  vcn_ocid                        = var.vcn_ocid
  vcn_cidr                        = local.vcn_cidr
  cluster_name                    = var.cluster_name
  pool_shapes                     = local.pool_shapes
  availability_domain             = data.oci_identity_availability_domain.availability_domain.name
  pool_formatter_id               = local.pool_formatter_id
  pool_replica_counts             = local.pool_replica_counts
  pool_ocpus                      = local.pool_ocpus
  pool_memories                   = local.pool_memories
  pool_boot_sizes                 = local.pool_boot_sizes
  pool_boot_volumes_vpus_per_gb   = local.pool_boot_volumes_vpus_per_gb
  private_subnet_id               = module.subnets.private_subnet_id
  nsg_ids                         = module.network_security_rules.nsg_ids
  image_id                        = module.discovery_images.image_id
}