# Internet Gateway


resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.simple_VPC.id
  tags = {
    Terraform = "true"
  }
}
