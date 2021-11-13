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

  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name = "CP1"

  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro"
  key_name               = var.key_name
  vpc_security_group_ids = [module.K8_VPC.default_security_group_id]
  subnet_id              = element(module.K8_VPC.subnets, 0)
  #user_data = "sudo apt-get update"
  user_data = <<-EOF
    #!/bin/bash
    sudo apt-get update
    sudo hostnamectl set-hostname master-node
    sudo apt-get install -y apt-transport-https curl
    curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
    sudo apt-add-repository "deb http://apt.kubernetes.io/ kubernetes-xenial main"
    sudo apt-get update
    sudo apt-get install -y kubeadm kubelet kubectl
    kubeadm version && kubelet --version && kubectl version
    sudo apt install -y awscli
  EOF


  tags = {
    Terraform = "true"
    Project   = var.project
  }
}



resource "aws_eip" "cp_eip" {
  vpc = true
  instance = module.ec2_instance.id
}


output "CP_ip" {
  value = aws_eip.cp_eip.public_ip
}
