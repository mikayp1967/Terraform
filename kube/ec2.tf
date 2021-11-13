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
  iam_instance_profile   = aws_iam_instance_profile.Kube_S3_profile.name
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



# Create role for EC2 and attach relevant policies
resource "aws_iam_role" "CP_IAM_S3" {
  name = "Kube_Node_IAM_Role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  inline_policy {
    name = "s3_read"

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action   = ["s3:GetObject"]
          Effect   = "Allow"
          #Resource = "arn:aws:s3:::key-store-bucket-390490349038000/*"
          Resource = format("arn:aws:s3:::%s/*",var.key_bucket)
        }
      ]
    })
  }
}

resource "aws_iam_instance_profile" "Kube_S3_profile" {
  name = "Kube_S3_profile"
  role = "${aws_iam_role.CP_IAM_S3.name}"
}


