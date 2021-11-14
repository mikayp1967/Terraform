module "K8_VPC_private" {
  source      = "../modules/vpc"
  cidr        = "10.0.10.0/24"
  subnet_cidr = ["10.0.11.0/26", "10.0.11.64/26", "10.0.11.128/26"]
  name        = "kubenet"
  az_list     = ["eu-west-2a", "eu-west-2b", "eu-west-2c"]
  project     = var.project
}


# Need to add SG ingress rule allowing 22 on my home net cidr




resource "aws_security_group" "K8_VPC_PRIV_SG" {
  name = "kube-sg"
  description = "Kubernetes SG"
  vpc_id = module.K8_VPC_private.vpc_id
  ingress {
    security_groups = [aws_security_group.K8_VPC_SG.id]
    from_port = 0
    to_port = 65535
    protocol = "tcp"
  }
  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 0
    to_port = 0
    protocol = "-1"
  }
  tags = {
    "Name" = "Kubernetes PRIV SG"
  }
}




