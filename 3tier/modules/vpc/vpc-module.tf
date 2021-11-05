resource "aws_vpc" "vpc_module" {
  cidr_block                       = "${var.cidr}"

}

resource "aws_subnet" "subnet_a" {
  availability_zone = "eu-west-2a"
  vpc_id = "${aws_vpc.vpc_module.id}"
  cidr_block = "${element(concat(var.subnet_cidr, list("")), 0)}"
  depends_on = ["aws_vpc.vpc_module"]
}


