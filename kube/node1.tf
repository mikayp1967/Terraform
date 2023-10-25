# EC2 and associated components for node





module "Node_instance" {

  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name = "NODE1"

  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  key_name               = var.key_name
  vpc_security_group_ids = [module.K8_VPC.default_security_group_id]
  subnet_id              = element(module.K8_VPC.subnets, 0)
  #subnet_id            = aws_subnet.subnets_priv.0.id                       # Why was this ever here?
  iam_instance_profile = aws_iam_instance_profile.Kube_Node_profile.name
  user_data            = file("scripts/90_node_install.sh")


  tags = {
    Terraform = "true"
    Project   = var.project
    Role      = "node"
  }
}


# Create role for EC2 and attach relevant policies
resource "aws_iam_role" "NODE_IAM_S3" {
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
          Action = ["s3:GetObject"]
          Effect = "Allow"
          #Resource = "arn:aws:s3:::key-store-bucket-390490349038000/*"
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


resource "aws_iam_instance_profile" "Kube_Node_profile" {
  name = "Kube_Node_profile"
  role = aws_iam_role.NODE_IAM_S3.name
}


output "node_IP" {
  description = "Private IP of node - so I can ssh in"
  value       = module.Node_instance.private_ip
}


resource "aws_eip" "node_eip" {
  vpc      = true
  instance = module.Node_instance.id
}


output "Node_ip" {
  value = aws_eip.node_eip.public_ip
}
