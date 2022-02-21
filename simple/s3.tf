resource "aws_s3_bucket" "bucket1" {
  bucket = "tf-test-bucket-919029"
  acl    = "private"

  tags = {
    Name        = "My bucket"
    Terraform   = "True"
    Environment = "Dev"
  }
}

