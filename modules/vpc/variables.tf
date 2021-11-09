variable "name" {
  description = "VPC name"
  type        = string
  default     = ""
}

variable "cidr" {
  description = "VPC CIDR range"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_cidr" {
  description = "CIDR range for the subnets"
  type        = list(string)
  default     = []
}

variable "az_list" {
  description = "List of AZs"
  type        = list(string)
  default     = []
}

variable "vpc_name" {
  description = "VPC name"
  type        = string
  default     = "Unnamed"
}

variable "project" {
  type    = string
  default = "UNKNOWN"
}
