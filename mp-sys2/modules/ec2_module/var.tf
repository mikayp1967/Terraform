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
  default = ""
}

variable "subnet_id_a" {
  default = ""
}

variable "subnet_id_b" {
  default = ""
}

variable "subnet_id_c" {
  default = ""
}

variable "availability_zone" {
    default = ""
}
