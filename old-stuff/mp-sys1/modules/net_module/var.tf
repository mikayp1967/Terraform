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
  default = ""
}

variable "subnet_id" {
  #default = {}
  default = ""
}

variable "availability_zone" {
    default = ""
}
