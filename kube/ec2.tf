# To get AMI filter patters find something similar and do the following from the cli:
#
# aws ec2 describe-images --image-ids=ami-0fdf70ed5c34c5f52|jq -r ".Images[]|[.OwnerId, .ImageLocation]|@tsv"


data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}





module "ec2_instance" {
  count = var.build_it == "Y" ? 1 : 0

  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name = "CP1"

  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro"
  key_name               = var.key_name
  vpc_security_group_ids = [module.K8_VPC.default_security_group_id]
  subnet_id              = element(module.K8_VPC.subnets, 0)

  tags = {
    Terraform = "true"
    Project   = var.project
  }
}
