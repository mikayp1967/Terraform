# Internet Gateway

resource "aws_internet_gateway" "igw" {
  vpc_id = module.K8_VPC.vpc_id
  tags = {
    Terraform = "true"
  }
}

# Add Route table and RTA so it can see the world
resource "aws_route_table" "igw_rt" {
  vpc_id = module.K8_VPC.vpc_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Terraform = "true"
    Name = "IGW RT"
  }
}

#resource "aws_route_table_association" "igw_rta" {
#  subnet_id      = element(module.K8_VPC.subnets, 0)
#  route_table_id = aws_route_table.igw_rt.id
#}

