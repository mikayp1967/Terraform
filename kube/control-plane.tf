# Install CP Instance and required components

module "ec2_instance" {

  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name = "CP1"

  ami                    = var.ec2_ami != "" ? var.ec2_ami : data.aws_ami.ubuntu.id
  instance_type          = "t3.small"
  key_name               = var.key_name
  vpc_security_group_ids = [module.K8_VPC.default_security_group_id]
  subnet_id              = element(module.K8_VPC.subnets, 0)
  iam_instance_profile   = aws_iam_instance_profile.Kube_S3_profile.name
  user_data              = file("scripts/10_master_install.sh")


  tags = {
    Terraform = "true"
    Project   = var.project
    Role = "Control-Plane" 
  }
}


resource "aws_eip" "cp_eip" {
  vpc      = true
  instance = module.ec2_instance.id
}


output "CP_ip" {
  value = aws_eip.cp_eip.public_ip
}


# Create role for EC2 and attach relevant policies
resource "aws_iam_role" "CP_IAM_S3" {
  name = "Kube_CP_IAM_Role"

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
          Action = ["s3:GetObject"]
          Effect = "Allow"
          Resource = format("arn:aws:s3:::%s/*", var.key_bucket)
        },
        {
          Action = ["ec2:Describe*"]
          Effect = "Allow"
          Resource = "*"
        },
        {
          Action = ["ec2:CreateVolume","ec2:AttachVolume","ec2:DetachVolume","ec2:DeleteVolume"]
          Effect = "Allow"
          Resource = "*"
        }
      ]
    })
  }
}

resource "aws_iam_instance_profile" "Kube_S3_profile" {
  name = "Kube_S3_profile"
  role = aws_iam_role.CP_IAM_S3.name
}


