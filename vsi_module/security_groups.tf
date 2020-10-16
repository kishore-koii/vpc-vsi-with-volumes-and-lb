##############################################################################
# ibm_is_security_group
##############################################################################

resource ibm_is_security_group allow_all {
  name           = "${var.unique_id}-allow-all"
  resource_group = var.resource_group_id
  vpc            = var.vpc_id
}

resource ibm_is_security_group_rule ingress {
  direction = "outbound"
  group     = ibm_is_security_group.allow_all.id
  remote    = "0.0.0.0/0"
}

resource ibm_is_security_group_rule egress {
  direction = "inbound"
  group     = ibm_is_security_group.allow_all.id
  remote    = "0.0.0.0/0"
}


##############################################################################