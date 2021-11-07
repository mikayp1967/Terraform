data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]

  tags = {
    Terraform   = "true"
  }
}

resource "aws_launch_configuration" "asg_config" {
  name          = "web_config"
  image_id      = "${data.aws_ami.ubuntu.id}"
  instance_type = "t2.micro"
  key_name      = "${var.key_name}"


  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "webservers" {
  name                 = "terraform-asg-webservers"
  launch_configuration = "${aws_launch_configuration.asg_config.name}"
  min_size             = 0
  max_size             = 0

  lifecycle {
    create_before_destroy = true
  }

  vpc_zone_identifier = ["${module.FE_VPC.subnets}"]


  tag = {
   key      ="Project"
   value = "${var.project}"
   propagate_at_launch = true
  }
}
