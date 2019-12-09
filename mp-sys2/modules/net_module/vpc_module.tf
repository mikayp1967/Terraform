resource "aws_vpc" "public_vpc" {
    cidr_block = "${var.cidr_block}"
    #cidr_block = "172.16.36.0/18"
    instance_tenancy = "default"
    tags = {
      Name = "public-sn\\\"-\\\""
    }
    enable_dns_support = "true"
    enable_dns_hostnames = "true"
}

resource "aws_subnet" "public_sna" {
    cidr_block = "${cidrsubnet(var.cidr_block,4,1)}"
    tags = {
        Name = "pub-sna"
    }
    availability_zone = "eu-west-2a"
    vpc_id = "${aws_vpc.public_vpc.id}"
    depends_on = ["aws_vpc.public_vpc"]

}
    
resource "aws_subnet" "public_snb" {
    cidr_block = "${cidrsubnet(var.cidr_block,4,2)}"
    tags = {
        Name = "pub-snb"
    }
    availability_zone = "eu-west-2b"
    vpc_id = "${aws_vpc.public_vpc.id}"
    depends_on = ["aws_vpc.public_vpc"]
}
    
resource "aws_subnet" "public_snc" {
    cidr_block = "${cidrsubnet(var.cidr_block,4,3)}"
    tags = {
        Name = "pub-snc"
    }
    availability_zone = "eu-west-2c"
    vpc_id = "${aws_vpc.public_vpc.id}"
    depends_on = ["aws_vpc.public_vpc"]
}


output "vpc_id" {
  value = "${aws_vpc.public_vpc.id}"
}
    

output "public_subnet_a" {
  value = "${aws_subnet.public_sna.id}"
}

output "public_subnet_b" {
  value = "${aws_subnet.public_snb.id}"
}

output "public_subnet_c" {
  value = "${aws_subnet.public_snc.id}"
}

