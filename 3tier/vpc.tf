resource "aws_vpc" "backend" {
  cidr_block = "10.0.0.0/24"
}

resource "aws_vpc" "frontend" {
  cidr_block = "10.0.1.0/24"
}

