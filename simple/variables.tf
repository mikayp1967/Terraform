variable "key_name" {
  default = "UNSET"
  type    = string
}

variable "project" {
  default = "Common components test env"
  type    = string
}


variable "home_net" {
  description = "home network CIDR addresses for SG ingress on SSH. Usually 80.4x.xx.xx so 11 bitmask should cover most that range"
  type        = list(any)
  default     = ["80.32.0.0/11"]
}

variable "public_subnet_cidr" {
  description = "CIDR range for the subnets"
  type        = list(string)
  default     = ["10.0.8.0/24", "10.0.9.0/24", "10.0.10.0/24"]
}

variable "cidr" {
  description = "CIDR of whole VPC"
  type        = string 
  default     = "10.0.0.0/16"
}

variable "priv_subnet_cidr" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.64.0/24", "10.0.65.0/24", "10.0.66.0/24"]
}

variable "az_list" {
  description = "List of AZs"
  type        = list(string)
  default     =["eu-west-2a", "eu-west-2b", "eu-west-2c" ]
}

variable "aws_region" {
  description = "Region to build in"
  type        = string
  default     = "eu-west-1"
}
