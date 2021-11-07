resource "aws_instance" "myec2_ws1" {
  ami = "${var.ami}"
  instance_type = "${var.instance_type}"
  subnet_id = "${var.subnet_id_a}"
  tags = {
      Name = "${var.ec2_name}-web1"
  }
  # availability_zone = "${var.availability_zone}"
}

resource "aws_instance" "myec2_ws2" {
  ami = "${var.ami}"
  instance_type = "${var.instance_type}"

  subnet_id = "${var.subnet_id_c}"

  tags = {
      Name = "${var.ec2_name}-web2"
  }
  #availability_zone = "${var.availability_zone}"
}

