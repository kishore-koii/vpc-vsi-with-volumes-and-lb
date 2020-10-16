##############################################################################
# Account Variables
##############################################################################

variable resource_group_id {
  description = "ID of resource group to create VPC"
  type        = string
}

variable unique_id {
  description = "The IBM Cloud platform API key needed to deploy IAM enabled resources"
  type        = string
  default     = "asset-module-vsi"
}

##############################################################################


##############################################################################
# VPC Variables
##############################################################################

variable vpc_id {
  description = "Name of VPC"
  type        = string
}

variable enable_fip {
  description = "Enable floating IP. Can be true or false"
  # type        = bool Currently IBM Schematics does not support `bool` variables. Uncomment when updated
  default     = true
}

variable subnet_ids {
  description = "A list of subnet IDs where VSI will be deployed"
  default     = []
}

variable subnet_zones {
  description = "A list of zones for the subnets"
}

##############################################################################


##############################################################################
# VSI Variables
##############################################################################

variable image {
  description = "Image name used for VSI. Run 'ibmcloud is images' to find available images in a region"
  type        = string
  default     = "ibm-centos-7-6-minimal-amd64-2"
}

variable ssh_public_key {
  description = "ssh public key to use for vsi"
  type        = string
}

variable machine_type {
  description = "VSI machine type. Run 'ibmcloud is instance-profiles' to get a list of regional profiles"
  type        =  string
  default     = "bx2-2x8"
}

variable vsi_per_subnet {
  description = "Number of VSI instances for each subnet"
  # type        = number Currently IBM Schematics does not support `number` variables. Uncomment when updated
  default     = 1
}

variable volumes {
  description = "A list of maps describng the volumes for each of the VSI"
  type        = list
}

##############################################################################