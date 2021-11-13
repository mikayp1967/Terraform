locals {
  igw_count = var.build_it == "Y" ? 1 : 0
}


module "K8_VPC" {
  source      = "../modules/vpc"
  cidr        = "10.0.10.0/24"
  subnet_cidr = ["10.0.10.0/26", "10.0.10.64/26", "10.0.10.128/26"]
  name        = "kubenet"
  az_list     = ["eu-west-2a", "eu-west-2b", "eu-west-2c"]
  project     = var.project
}


# Need to add SG ingress rule allowing 22 on my home net cidr

resource "aws_security_group_rule" "home_net_ingress" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = var.home_net
  security_group_id = module.K8_VPC.default_security_group_id
}

resource "aws_security_group_rule" "local_net_ingress" {
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  self              = true
  security_group_id = module.K8_VPC.default_security_group_id
}

