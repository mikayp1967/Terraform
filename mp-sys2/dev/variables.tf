variable "cidr_vpc" {
    default = "192.168.0.0/16"
   # 192.168.0.0 - 192.168.255.255
}

variable "cidr_instance_tenancy" {
    default = "dedicated"
  
}


variable "cidr_subnet" {
    #192.168.1.0 - 192.168.1.255
    default = "192.168.1.0/24"
}

variable "availability_zone" {
  default = "eu-west-2a"
}




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

variable "web_subnet" {
  #default = {}
  default = "subnet-0d44efe1e45c20546"
}



