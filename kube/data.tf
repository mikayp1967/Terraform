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

