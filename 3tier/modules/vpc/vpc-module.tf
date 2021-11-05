resource "aws_vpc" "vpc_module" {
  cidr_block                       = "${var.cidr}"

}

resource "aws_subnet" "subnets" {
  count = "${length(var.subnet_cidr)}"
  availability_zone = "${element(var.az_list, count.index)}"
  vpc_id = "${aws_vpc.vpc_module.id}"
  cidr_block = "${element(concat(var.subnet_cidr, list("")), count.index)}"
  depends_on = ["aws_vpc.vpc_module"]
}


