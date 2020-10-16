##############################################################################
# Account Variables
##############################################################################

variable ibmcloud_api_key {
  description = "The IBM Cloud platform API key needed to deploy IAM enabled resources"
  type        = string
}

variable ibm_region {
  description = "IBM Cloud region where all resources will be deployed"
  type        = string
  default     = "us-south"
}

variable generation {
  description = "Generation of VPC"
  type        = number
  default     = 2
}

variable resource_group {
  description = "Name of resource group to create VPC"
  type        = string
  default     = "asset-development"
}

variable vpc_name {
  description = "Name of VPC"
  type        = string
}

variable unique_id {
  description = "The IBM Cloud platform API key needed to deploy IAM enabled resources"
  type        = string
  default     = "asset-module-lb"
}


##############################################################################


##############################################################################
# VSI Variables
##############################################################################

variable image {
  description = "Image name used for VSI. Run 'ibmcloud is images' to find available images in a region"
  type        = string
  default     = "ibm-ubuntu-18-04-1-minimal-amd64-1"
}

variable subnet_ids {
  description = "A list of subnet ids where VSI will be deployed. Must exist within the VPC"
  type        = list(string)
  default     = [
  ]
}

variable vsi_per_subnet {
    description = "Number of VSI instances for each subnet. All VSI will be connected by a single load balancer"
    type        = number
    default     = 2
}

variable ssh_public_key {
  description = "ssh public key to use for vsi"
  type        = string
}

variable machine_type {
  description = "VSI machine type. Run 'ibmcloud is instance-profiles' to get a list of regional profiles. For Gen 1 use bc1-2x8, for Gen 2 use bx2-2x8"
  type        =  string
  default     = "bc1-2x8"
}


variable enable_fip {
  description = "Enable floating IP. Can be true or false"
  type        = bool
  default     = false
}

variable volumes {
  description = "A list of maps describng the volumes for each of the VSI"
  /*
  type         = list(object({
      name           = string   
      profile        = string
      iops           = number       # Optional
      capacity       = number       # Optional
      encryption_key = string       # Optional
      tags           = list(string) # Optional
  }))
  */
  default     = [
    {
      name     = "one"
      profile  = "10iops-tier"
      capacity = 25
    },
    {
      name    = "two"
      profile = "10iops-tier"
    },
    {
      name    = "three"
      profile = "10iops-tier"
    }
  ]
}


##############################################################################


##############################################################################
# LB Variables
##############################################################################

variable type {
    description = "Load Balancer type, can be public or private"
    type        = string
    default     = "public"
}

variable listener_port {
    description = "Listener port"
    type       = number
    default     = 80
}

##############################################################################


##############################################################################
# Listener Variables
##############################################################################

variable listener_protocol {
    description = "The listener protocol. Supported values are http, tcp, and https"
    type        = string
    default     = "http"
}

variable certificate_instance {
    description = "Optional, the CRN of a certificate instance to use with the load balancer."
    type        = string
    default     = ""
}

variable connection_limit {
    description = "Optional, connection limit for the listener. Valid range 1 to 15000."
    type        = number
    default     = 0
}

##############################################################################


##############################################################################
# Pool Variables
##############################################################################

variable algorithm {
    description = "The load balancing algorithm. Supported values are round_robin, or least_connections. This module can be modified to use weighted_round_robin by adding `weight` to the load balancer pool members."
    type        = string
    default     = "round_robin"
}

variable protocol {
    description = "The pool protocol. Supported values are http, and tcp."
    type        = string    
    default     = "http"
}

variable health_delay {
    description = "The health check interval in seconds. Interval must be greater than timeout value."
    type        = number
    default     = 11
}

variable health_retries {
    description = "The health check max retries."
    type       = number
    default     = 10
}

variable health_timeout {
    description = "The health check timeout in seconds."
    type       = number
    default     = 10    
}

variable health_type {
    description = "The pool protocol. Supported values are http, and tcp."
    type        = string
    default     = "http"
}

##############################################################################


##############################################################################
# Pool Member Variables
##############################################################################

variable pool_member_port {
    description = "The port number of the application running in the server member."
    default     = 80
}

##############################################################################