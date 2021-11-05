variable "name" {
  description = "VPC name"
  default     = ""
}

variable "cidr" {
  description = "VPC CIDR range"
  default     = "10.0.0.0/16"
}

variable "subnet_cidr" {
  description = "CIDR range for the subnets"
  default     = []
}

variable "az_list" {
    description = "List of AZs"
    default = []
}
