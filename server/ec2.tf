data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}



resource "aws_instance" "my-ec2" {
  ami                  = data.aws_ami.ubuntu.id
  instance_type        = "t3.micro"
  iam_instance_profile = aws_iam_instance_profile.EC2_S3_profile.name
  tags = {
    Name      = "test-ec2"
    Terraform = "True"
  }
}



resource "aws_s3_bucket" "bucket1" {
  bucket = "tf-test-bucket-919029"
  acl    = "private"

  tags = {
    Name        = "My bucket"
    Terraform   = "True"
    Environment = "Dev"
  }
}


resource "aws_iam_role" "EC2_IAM_S3" {
  name = "S3_IAM_Role"

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
          Action   = ["s3:*"]
          Effect   = "Allow"
          Resource = "arn:aws:s3:::tf-test-bucket-919029/*"
        },
      ]
    })
  }
}

resource "aws_iam_instance_profile" "EC2_S3_profile" {
  name = "EC2_S3_profile"
  role = aws_iam_role.EC2_IAM_S3.name
}
