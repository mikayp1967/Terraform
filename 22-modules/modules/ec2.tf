resource "aws_instance" "ec2_test1" {

  ami = ""
  instance_type = ""
  security_groups = ["DEFAULT"]
  
  tags = {
    Name = "ec2_test1"
  }
}


