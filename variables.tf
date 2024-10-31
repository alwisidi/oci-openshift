variable "region" {
  type = string
}

variable "tenancy_ocid" {
  type        = string
  description = "The ocid of the current tenancy."
}

variable "compartment_ocid" {
  type        = string
  description = "The ocid of the compartment where you wish to create the OpenShift cluster."
}

variable "vcn_ocid" {
  type        = string
  description = "The ocid of the virtual cloud network where you wish to create the OpenShift cluster."
}

variable "cluster_name" {
  type        = string
  description = "The name of your OpenShift cluster. It should be the same as what was specified when creating the OpenShift ISO and it should be DNS compatible. The cluster_name value must be 1-54 characters. It can use lowercase alphanumeric characters or hyphen (-), but must start and end with a lowercase letter or a number."
}

variable "openshift_image_source_uri" {
  type        = string
  description = "The OCI Object Storage URL for the OpenShift image. Before provisioning resources through this Resource Manager stack, users should upload the OpenShift image to OCI Object Storage, create a pre-authenticated requests (PAR) uri, and paste the uri to this block. For more detail regarding Object storage and PAR, please visit https://docs.oracle.com/en-us/iaas/Content/Object/Concepts/objectstorageoverview.htm and https://docs.oracle.com/en-us/iaas/Content/Object/Tasks/usingpreauthenticatedrequests.htm ."
}

variable "control_plane_shape" {
  default     = "VM.Standard.E5.Flex"
  type        = string
  description = "Compute shape of the control_plane nodes. The default shape is VM.Standard.E5.Flex. For more detail regarding compute shapes, please visit https://docs.oracle.com/en-us/iaas/Content/Compute/References/computeshapes.htm ."
}

variable "infra_shape" {
  default     = "VM.Standard.E5.Flex"
  type        = string
  description = "Compute shape of the infra nodes. The default shape is VM.Standard.E5.Flex. For more detail regarding compute shapes, please visit https://docs.oracle.com/en-us/iaas/Content/Compute/References/computeshapes.htm ."
}

variable "storage_shape" {
  default     = "VM.Standard.E5.Flex"
  type        = string
  description = "Compute shape of the storage nodes. The default shape is VM.Standard.E5.Flex. For more detail regarding compute shapes, please visit https://docs.oracle.com/en-us/iaas/Content/Compute/References/computeshapes.htm ."
}

variable "compute_shape" {
  default     = "VM.Standard.E5.Flex"
  type        = string
  description = "Compute shape of the compute nodes. The default shape is VM.Standard.E5.Flex. For more detail regarding compute shapes, please visit https://docs.oracle.com/en-us/iaas/Content/Compute/References/computeshapes.htm ."
}

# --- Load Balancers Variables --- #
variable "load_balancer_shape_details_maximum_bandwidth_in_mbps" {
  default     = 400
  type        = number
  description = "Bandwidth in Mbps that determines the maximum bandwidth (ingress plus egress) that the load balancer can achieve. The values must be between minimumBandwidthInMbps and 8000"

  validation {
    condition     = var.load_balancer_shape_details_maximum_bandwidth_in_mbps >= 10 && var.load_balancer_shape_details_maximum_bandwidth_in_mbps <= 8000
    error_message = "The load_balancer_shape_details_maximum_bandwidth_in_mbps value must be between load_balancer_shape_details_minimum_bandwidth_in_mbps and 8000."
  }
}
variable "load_balancer_shape_details_minimum_bandwidth_in_mbps" {
  default     = 10
  type        = number
  description = " Bandwidth in Mbps that determines the total pre-provisioned bandwidth (ingress plus egress). The values must be between 10 and the maximumBandwidthInMbps"

  validation {
    condition     = var.load_balancer_shape_details_minimum_bandwidth_in_mbps >= 10 && var.load_balancer_shape_details_minimum_bandwidth_in_mbps <= 8000
    error_message = "The load_balancer_shape_details_maximum_bandwidth_in_mbps value must be between 10 and load_balancer_shape_details_maximum_bandwidth_in_mbps."
  }
}

# --- DNS Records Variables --- #
variable "zone_dns" {
  # Company's domain which the openshift records will be populated from like following:
  # *.cluster_name.company.domain
  # default     = "EXAMPLE.COM"
  type        = string
  description = "The name of cluster's DNS zone. This name must be the same as what was specified during OpenShift ISO creation. The zone_dns value must be a valid hostname."
}

variable "dns_zone_ocid" {
  # Expected to have a static Zone to host all records.
  # default     = "YOUR_DEFAULT_ZONE_OCID"
  type        = string
  description = "The ocid of the dns zone where you wish to create the rrsets."
}

# --- Control Plane Pool Variables --- #

variable "control_plane_replica_count" {
  default     = 3
  type        = number
  description = "The number of control_plane nodes in the cluster. The default value is 3. "
}
variable "control_plane_ocpu" {
  default     = 4
  type        = number
  description = "The number of OCPUs available for the shape of each control_plane node. The default value is 4. "

  validation {
    condition     = var.control_plane_ocpu >= 1 && var.control_plane_ocpu <= 114
    error_message = "The control_plane_ocpu value must be between 1 and 114."
  }
}
variable "control_plane_memory" {
  default     = 32
  type        = number
  description = "The amount of memory available for the shape of each control_plane node, in gigabytes. The default value is 16. "

  validation {
    condition     = var.control_plane_memory >= 1 && var.control_plane_memory <= 1760
    error_message = "The control_plane_memory value must be between the value of control_plane_ocpu and 1760."
  }
}
variable "control_plane_boot_size" {
  default     = 1024
  type        = number
  description = "The size of the boot volume of each control_plane node in GBs. The minimum value is 50 GB and the maximum value is 32,768 GB (32 TB). The default value is 1024 GB. "

  validation {
    condition     = var.control_plane_boot_size >= 50 && var.control_plane_boot_size <= 32768
    error_message = "The control_plane_boot_size value must be between 50 and 32768."
  }
}
variable "control_plane_boot_volume_vpus_per_gb" {
  default     = 90
  type        = number
  description = "The number of volume performance units (VPUs) that will be applied to this volume per GB of each control_plane node. The default value is 90. "

  validation {
    condition     = var.control_plane_boot_volume_vpus_per_gb >= 10 && var.control_plane_boot_volume_vpus_per_gb <= 120 && var.control_plane_boot_volume_vpus_per_gb % 10 == 0
    error_message = "The control_plane_boot_volume_vpus_per_gb value must be between 10 and 120, and must be a multiple of 10."
  }
}

# --- Infra Pool Variables --- #

variable "infra_replica_count" {
  default     = 3
  type        = number
  description = "The number of infra nodes in the cluster. The default value is 3. "
}
variable "infra_ocpu" {
  default     = 5
  type        = number
  description = "The number of OCPUs available for the shape of each infra node. The default value is 4. "

  validation {
    condition     = var.infra_ocpu >= 1 && var.infra_ocpu <= 114
    error_message = "The infra_ocpu value must be between 1 and 114."
  }
}
variable "infra_memory" {
  default     = 32
  type        = number
  description = "The amount of memory available for the shape of each infra node, in gigabytes. The default value is 16. "

  validation {
    condition     = var.infra_memory >= 1 && var.infra_memory <= 1760
    error_message = "The infra_memory value must be between the value of infra_ocpu and 1760."
  }
}
variable "infra_boot_size" {
  default     = 256
  type        = number
  description = "The size of the boot volume of each infra node in GBs. The minimum value is 50 GB and the maximum value is 32,768 GB (32 TB). The default value is 1024 GB. "

  validation {
    condition     = var.infra_boot_size >= 50 && var.infra_boot_size <= 32768
    error_message = "The infra_boot_size value must be between 50 and 32768."
  }
}
variable "infra_boot_volume_vpus_per_gb" {
  default     = 30
  type        = number
  description = "The number of volume performance units (VPUs) that will be applied to this volume per GB of each infra node. The default value is 90. "

  validation {
    condition     = var.infra_boot_volume_vpus_per_gb >= 10 && var.infra_boot_volume_vpus_per_gb <= 120 && var.infra_boot_volume_vpus_per_gb % 10 == 0
    error_message = "The infra_boot_volume_vpus_per_gb value must be between 10 and 120, and must be a multiple of 10."
  }
}

# --- Storage Pool Variables --- #

variable "storage_replica_count" {
  default     = 3
  type        = number
  description = "The number of storage nodes in the cluster. The default value is 3. "
}
variable "storage_ocpu" {
  default     = 8
  type        = number
  description = "The number of OCPUs available for the shape of each storage node. The default value is 4. "

  validation {
    condition     = var.storage_ocpu >= 1 && var.storage_ocpu <= 114
    error_message = "The storage_ocpu value must be between 1 and 114."
  }
}
variable "storage_memory" {
  default     = 32
  type        = number
  description = "The amount of memory available for the shape of each storage node, in gigabytes. The default value is 16. "

  validation {
    condition     = var.storage_memory >= 1 && var.storage_memory <= 1760
    error_message = "The storage_memory value must be between the value of storage_ocpu and 1760."
  }
}
variable "storage_boot_size" {
  default     = 256
  type        = number
  description = "The size of the boot volume of each storage node in GBs. The minimum value is 50 GB and the maximum value is 32,768 GB (32 TB). The default value is 1024 GB. "

  validation {
    condition     = var.storage_boot_size >= 50 && var.storage_boot_size <= 32768
    error_message = "The storage_boot_size value must be between 50 and 32768."
  }
}
variable "storage_boot_volume_vpus_per_gb" {
  default     = 30
  type        = number
  description = "The number of volume performance units (VPUs) that will be applied to this volume per GB of each storage node. The default value is 90. "

  validation {
    condition     = var.storage_boot_volume_vpus_per_gb >= 10 && var.storage_boot_volume_vpus_per_gb <= 120 && var.storage_boot_volume_vpus_per_gb % 10 == 0
    error_message = "The storage_boot_volume_vpus_per_gb value must be between 10 and 120, and must be a multiple of 10."
  }
}
variable "storage_block_size" {
  default     = 512
  type        = number
  description = "The size of the block volume of each storage node in GBs. The minimum value is 50 GB and the maximum value is 32,768 GB (32 TB). The default value is 1024 GB. "

  # validation {
  #   condition     = var.storage_boot_size >= 50 && var.storage_boot_size <= 32768
  #   error_message = "The storage_boot_size value must be between 50 and 32768."
  # }
}

# --- Compute Pool Variables --- #
variable "compute_replica_count" {
  default     = 3
  type        = number
  description = "The number of compute nodes in the cluster. The default value is 3. "
}
variable "compute_ocpu" {
  default     = 5
  type        = number
  description = "The number of OCPUs available for the shape of each compute node. The default value is 4. "

  validation {
    condition     = var.compute_ocpu >= 1 && var.compute_ocpu <= 114
    error_message = "The compute_ocpu value must be between 1 and 114."
  }
}
variable "compute_memory" {
  default     = 32
  type        = number
  description = "The amount of memory available for the shape of each compute node, in gigabytes. The default value is 16. "

  validation {
    condition     = var.compute_memory >= 1 && var.compute_memory <= 1760
    error_message = "The compute_memory value must be between the value of compute_ocpu and 1760."
  }
}
variable "compute_boot_size" {
  default     = 256
  type        = number
  description = "The size of the boot volume of each compute node in GBs. The minimum value is 50 GB and the maximum value is 32,768 GB (32 TB). The default value is 1024 GB. "

  validation {
    condition     = var.compute_boot_size >= 50 && var.compute_boot_size <= 32768
    error_message = "The compute_boot_size value must be between 50 and 32768."
  }
}
variable "compute_boot_volume_vpus_per_gb" {
  default     = 30
  type        = number
  description = "The number of volume performance units (VPUs) that will be applied to this volume per GB of each compute node. The default value is 90. "

  validation {
    condition     = var.compute_boot_volume_vpus_per_gb >= 10 && var.compute_boot_volume_vpus_per_gb <= 120 && var.compute_boot_volume_vpus_per_gb % 10 == 0
    error_message = "The compute_boot_volume_vpus_per_gb value must be between 10 and 120, and must be a multiple of 10."
  }
}