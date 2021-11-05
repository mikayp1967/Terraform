#!/bin/bash

# create basic config structure for terraform project
#
#

cat > variables.tf <<EOF
variable "example_var" {
}
EOF


cat > provider.tf <<EOF
variable "example_var" {
}
EOF


cat > main.tf <<EOF
# Empty file
EOF

mkdir modules
TF_MAJOR=$( terraform version|head -1|sed 's/.* v//'|awk -F"." '{print $1}')
TF_MINOR=$( terraform version|head -1|sed 's/.* v//'|awk -F"." '{print $2}')

if [[ ${TF_MAJOR} == "0" && ${TF_MINOR} <"13" ]]; then
    printf "Terraform old style providers"
    cat > provider.tf << EOF
provider "aws" {
  version = "~> 3.0"
  region  = "eu-west-2"
}
EOF
else
    printf "Terraform new style providers"
    cat > provider.tf << EOF
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "eu-west-2"
}
EOF
fi





