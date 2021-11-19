variable "example_var" {
  default = "Example"
  type    = string
}

variable "key_name" {
  default = "UNSET"
  type    = string
}

variable "project" {
  default = "Simple K8 playground"
  type    = string
}

variable "build_it" {
  description = "Whether to build certain resource that have cost associated or not, value = Y/N"
  type        = string
  default     = "Y"
}

variable "home_net" {
  description = "home network CIDR addresses for SG ingress on SSH"
  type        = list(any)
  default     = [""]
}

variable "key_bucket" {
  description = "Bucket name where key for CP-node comms is stored so I can uise CP as jumpbox and login to nodes"
  type        = string
  default     = ""
}

variable "priv_subnet_cidr" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.11.0/24", "10.0.12.0/24", "10.0.13.0/24"]
}

variable "aws_region" {
  description = "Region to build in"
  type        = string
  default     = "eu-west-1"
}
