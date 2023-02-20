terraform {
  required_providers {
    ibm = {
	  # source is mandatory for community providers
      source = "IBM-Cloud/ibm" 
      version = "1.13.1"
    }
  }
}
##############################################################################
# IBM Cloud Provider
##############################################################################

provider ibm {
  ibmcloud_api_key      = var.ibmcloud_api_key
  region                = var.ibm_region
  generation            = var.generation
  ibmcloud_timeout      = 60
}

##############################################################################


##############################################################################
# VPC Data Block
##############################################################################

data ibm_is_vpc vpc {
    name = var.vpc_name
}

##############################################################################


##############################################################################
# Resource Group for VSI and Load Balancer
##############################################################################

data ibm_resource_group group {
  name = var.resource_group
}

##############################################################################

##############################################################################
# Get IDs for subnets
##############################################################################

data ibm_is_subnet subnet {
  count      = length(var.subnet_ids)
  identifier = var.subnet_ids[count.index]
}

##############################################################################


##############################################################################
# Create VSI
##############################################################################

module vsi {
  source            = "./vsi_module"
  unique_id         = var.unique_id
  image             = var.image
  ssh_public_key    = var.ssh_public_key  
  machine_type      = var.machine_type
  vsi_per_subnet    = var.vsi_per_subnet
  enable_fip        = var.enable_fip  
  resource_group_id = data.ibm_resource_group.group.id
  vpc_id            = data.ibm_is_vpc.vpc.id
  subnet_zones      = data.ibm_is_subnet.subnet.*.zone
  subnet_ids        = var.subnet_ids
  volumes           = var.volumes
}

##############################################################################


##############################################################################
# Create Load Balancer For VSI
##############################################################################

module lb {
  source               = "./lb_module"
  unique_id            = var.unique_id
  subnet_list          = data.ibm_is_subnet.subnet.*.id
  vsi_list             = module.vsi.vsi
  resource_group_id    = data.ibm_resource_group.group.id
  type                 = var.type
  listener_port        = var.listener_port
  listener_protocol    = var.listener_protocol
  certificate_instance = var.certificate_instance
  connection_limit     = var.connection_limit
  algorithm            = var.algorithm
  protocol             = var.protocol
  health_delay         = var.health_delay
  health_retries       = var.health_retries
  health_timeout       = var.health_timeout
  health_type          = var.health_type
  pool_member_port     = var.pool_member_port
}

##############################################################################
