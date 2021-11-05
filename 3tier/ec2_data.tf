data "aws_ami" "al2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}


module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> v1.0"

  instance_count = 1

  name = "webserver"

  ami                    = "${data.aws_ami.al2.id}"
  instance_type          = "t2.micro"
  key_name               = "AWS1"
  monitoring             = false
  subnet_id              = "subnet-01ade349bcda098a1"
  vpc_security_group_ids = ["sg-0b5f4a1f60a332548"]

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}
