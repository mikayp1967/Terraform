variable "ami" {
  default = "ami-05f37c3995fffb4fd"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "ec2_name" {
  default = ""
}



variable "vpc_id" {
  #default = {}
  default = "vpc-055b547b95c79c9d1"
}

variable "subnet_id" {
  #default = {}
  default = "subnet-0d44efe1e45c20546"
}

