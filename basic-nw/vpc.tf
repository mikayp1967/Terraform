
module "FE_VPC" {
  source      = "../modules/vpc"
  cidr        = "10.0.1.0/24"
  subnet_cidr = ["10.0.1.0/26", "10.0.1.64/26", "10.0.1.128/26"]
  name        = "frontend"
  az_list     = ["eu-west-2a", "eu-west-2b", "eu-west-2c"]
  project = "${var.project}"
}

module "BE_VPC" {
  source      = "../modules/vpc"
  cidr        = "10.0.2.0/24"
  subnet_cidr = ["10.0.2.0/26", "10.0.2.64/26", "10.0.2.128/26"]
  name        = "backend"
  az_list     = ["eu-west-2a", "eu-west-2b", "eu-west-2c"]
  project = "${var.project}"
}


resource "aws_internet_gateway" "igw" {
  vpc_id = "${module.FE_VPC.vpc_id}"


  tags = {
    Terraform   = "true"
  }
}


resource "aws_eip" "ngw_eip" {
  vpc      = true
}


resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = "${aws_eip.ngw_eip.id}"
  subnet_id = "${element(module.FE_VPC.subnets,0)}"
  tags = {
    "Name" = "NatGateway"
  }
}




