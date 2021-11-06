module "BE_VPC" {
  source      = "../modules/vpc"
  cidr        = "10.0.1.0/24"
  subnet_cidr = ["10.0.1.0/26", "10.0.1.64/26", "10.0.1.128/26"]
  name        = "backend"
  az_list     = ["eu-west-2a", "eu-west-2b", "eu-west-2c"]
}
