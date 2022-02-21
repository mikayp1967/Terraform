locals {
  az_list   = ["eu-west-2a", "eu-west-2b", "eu-west-2c"]
  common_tags = {
    Terraform   = "True"
    Project     = var.project
    CreatedDate = timestamp()
  }
}

