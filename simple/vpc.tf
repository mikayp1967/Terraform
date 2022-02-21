# I did a VPC "module" for the K8s project but it sucks so gonna just write this here
# Plus the whole point of this little project is to get a little refresher after a bit of time out


resource "aws_vpc" "simple_VPC" {
  cidr_block = var.cidr

  tags = {
    Terraform = "true"
    Name      = format("%s %s", var.project, "VPC")
  }
}

resource "aws_subnet" "public_subnets" {
  count             = length(var.public_subnet_cidr)
  availability_zone = element(var.az_list, count.index)
  vpc_id            = aws_vpc.simple_VPC.id
  cidr_block        = element(concat(var.public_subnet_cidr, [""]), count.index)

  tags = {
    Terraform = "true"
    project   = var.project
    Name      = format("%s-%d", "public-SN-", count.index)
  }
}









resource "aws_security_group" "Simple_VPC_SG" {
  name        = "simple-sg"
  description = "Simple playground project SG"
  vpc_id      = aws_vpc.simple_VPC.id
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
    "Name" = "Simple playground project SG"
    },
  )
}

