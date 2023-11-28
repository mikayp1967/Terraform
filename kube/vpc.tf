locals {
  igw_count = var.build_it == "Y" ? 1 : 0
  az_list   = ["eu-west-2a", "eu-west-2b", "eu-west-2c"]
  common_tags = {
    Terraform   = "true"
    Project     = var.project
    CreatedDate = timestamp()
  }
}


module "K8_VPC" {
  source      = "../modules/vpc"
  cidr        = "10.0.0.0/16"
  subnet_cidr = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  name        = "kubenet"
  az_list     = ["eu-west-2a", "eu-west-2b", "eu-west-2c"]
  project     = var.project
}


# Need to add SG ingress rule allowing 22 on my home net cidr




resource "aws_security_group" "K8_VPC_SG" {
  name        = "kube-sg"
  description = "Kubernetes SG"
  vpc_id      = module.K8_VPC.vpc_id
  ingress {
    cidr_blocks = var.home_net
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  }
  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
  }
  lifecycle {
    ignore_changes = [
      tags["CreatedDate"]
    ]
  }
  tags = merge(local.common_tags, {
    "Name" = "Kubernetes SG"
    },
  )
}



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

# I made a vpc module basically for the sake of making a module - seems so dumb now...

resource "aws_subnet" "subnets_priv" {
  count = length(var.priv_subnet_cidr)

  availability_zone = element(local.az_list, count.index)
  vpc_id            = module.K8_VPC.vpc_id
  cidr_block        = element(concat(var.priv_subnet_cidr, [""]), count.index)
  depends_on        = [module.K8_VPC]

  lifecycle {
    ignore_changes = [
      tags["CreatedDate"]
    ]
  }
  tags = merge(local.common_tags, {
    "Name" = format("K8s-priv-SN-%d", count.index)
    },
  )
}


# Route table resources

resource "aws_route_table" "subnet_priv_rt" {
  vpc_id = module.K8_VPC.vpc_id
  lifecycle {
    ignore_changes = [
      tags["CreatedDate"]
    ]
  }
  tags = merge(local.common_tags, {
    "Name" = "Priv RT"
    },
  )

}

resource "aws_route_table_association" "subnet_priv_rta" {
  count          = length(var.priv_subnet_cidr)
  subnet_id      = element(aws_subnet.subnets_priv.*.id, count.index)
  route_table_id = aws_route_table.subnet_priv_rt.id
}


