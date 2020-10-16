##############################################################################
# SSH key for creating VSI
##############################################################################

resource ibm_is_ssh_key ssh_key {
  name       = "${var.unique_id}-ssh-key"
  public_key = var.ssh_public_key
}

##############################################################################


##############################################################################
# Image Data Block
##############################################################################

data ibm_is_image image {
    name = var.image
}

##############################################################################



##############################################################################
# Create Volumes
##############################################################################

module volumes {
  source            = "./volume_module"
  unique_id         = var.unique_id
  volumes           = var.volumes
  vsi_per_subnet    = var.vsi_per_subnet
  subnet_ids        = var.subnet_ids
  subnet_zones      = var.subnet_zones
  resource_group_id = var.resource_group_id
}

##############################################################################


##############################################################################
# Locals
##############################################################################

locals {
  # Total number of VSI
  vsi_count = var.vsi_per_subnet * length(var.subnet_ids)
}

##############################################################################



##############################################################################
# Provision VSI
##############################################################################

resource ibm_is_instance vsi {
  count          = local.vsi_count

  name           = "${var.unique_id}-vsi-${count.index + 1}"
  image          = data.ibm_is_image.image.id
  profile        = var.machine_type
  resource_group = var.resource_group_id

  primary_network_interface {
    subnet   = element(var.subnet_ids, floor(count.index / var.vsi_per_subnet))
    security_groups = [
      ibm_is_security_group.allow_all.id
    ]
  }  

  user_data  = file("${path.module}/config/ubuntu_install_nginx.sh")
                 
  vpc        = var.vpc_id
  zone       = element(
      var.subnet_zones,
      index(
        var.subnet_ids, 
        element(var.subnet_ids, floor(count.index / var.vsi_per_subnet))
      )
  )

  keys       = [ibm_is_ssh_key.ssh_key.id]
  volumes    = length(var.volumes) > 0 ? module.volumes.ids[count.index] : null
}

##############################################################################


##############################################################################
# Provision Floating IPs for Subnets
##############################################################################

resource ibm_is_floating_ip vsi_fip {
  count  = var.enable_fip ? var.vsi_per_subnet * length(var.subnet_ids) : 0
  name   = "${var.unique_id}-fip-${count.index + 1}"
  target = element(ibm_is_instance.vsi.*.primary_network_interface.0.id, count.index)
}

##############################################################################