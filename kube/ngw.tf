# NGW/EIP are charged resources so they are spun off here and I can basically rename tis file to delete them easily
# Pretty sure there is an easier way but I don't know it - yet!


# Internet Gateway - moveid to diff file.




# Route table resources

resource "aws_route_table" "ngw_rt" {
  vpc_id = module.K8_VPC.vpc_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "ngw_rta" {
  subnet_id      = element(module.K8_VPC.subnets, 0)
  route_table_id = aws_route_table.ngw_rt.id
}




# EIP resources

resource "aws_eip" "ngw_eip" {
  vpc = true
}


resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.ngw_eip.id
  subnet_id     = element(module.K8_VPC.subnets, 0)
  tags = {
    Terraform = "true"
    "Name"    = "NatGateway"
  }
}
