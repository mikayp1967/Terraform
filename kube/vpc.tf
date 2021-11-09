module "K8_VPC" {
  source      = "../modules/vpc"
  cidr        = "10.0.10.0/24"
  subnet_cidr = ["10.0.10.0/26", "10.0.10.64/26", "10.0.10.128/26"]
  name        = "kubenet"
  az_list     = ["eu-west-2a", "eu-west-2b", "eu-west-2c"]
  project     = var.project
}


# NGW/EIP/IGW removed as no point paying cost just yet

