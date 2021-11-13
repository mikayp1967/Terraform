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
  type = list
  default = ["80.44.0.0/16"]
}
