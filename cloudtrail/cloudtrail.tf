data "aws_caller_identity" "current" {}

resource "aws_cloudtrail" "my-trail" {
  name                          = "tf-trail-my-trail"
  s3_bucket_name                = aws_s3_bucket.trail-log.id
  s3_key_prefix                 = "prefix"
  include_global_service_events = false
}

resource "aws_s3_bucket" "trail-log" {
  bucket        = "trail-log-1234512345"
  force_destroy = true

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AWSCloudTrailAclCheck",
            "Effect": "Allow",
            "Principal": {
              "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:GetBucketAcl",
            "Resource": "arn:aws:s3:::trail-log-1234512345"
        },
        {
            "Sid": "AWSCloudTrailWrite",
            "Effect": "Allow",
            "Principal": {
              "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::trail-log-1234512345/prefix/AWSLogs/${data.aws_caller_identity.current.account_id}/*",
            "Condition": {
                "StringEquals": {
                    "s3:x-amz-acl": "bucket-owner-full-control"
                }
            }
        }
    ]
}
POLICY
    logging {
        target_bucket = aws_s3_bucket.trail-log-logging.id
        target_prefix = "trails/"
      }
}


resource "aws_s3_bucket" "trail-log-logging" {
  bucket        = "trail-log-logging-1234512345"
  force_destroy = true
}

