provider "aws" {
  region = "us-east-1"
  access_key = "Paste your access key here"
  secret_key = "Paste your secret key here"

}

provider "aws" {
  alias = "frankfurt"
  region = "eu-central-1"
  access_key = "Paste your access key here"
  secret_key = "Paste your secret key here"

}
