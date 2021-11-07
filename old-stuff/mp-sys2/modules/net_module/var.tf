variable "cidr_block" {
  default = "172.31.0.0/16"
}



variable "cidr_subnets" {
  default = ["172.31.0.0/24", "172.31.16.0/24", "172.31.32.0/24"]
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
