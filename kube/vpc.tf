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



