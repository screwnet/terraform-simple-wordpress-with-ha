# Create a logging bucket to store logs

data "aws_caller_identity" "current" {}
data "aws_elb_service_account" "wp_alb" {} #finds the elb account id of the provider region

resource "aws_s3_bucket" "logging_bucket" {
  bucket        = "logging-bucket-for-wp-screwnet"
  acl           = "log-delivery-write"
  force_destroy = true
  versioning {
    enabled = true
  }
  tags = var.tags
}

# Create an S3 bucket to store static content
resource "aws_s3_bucket" "cloudfrontbucket" {
  bucket = "static-files-for-wp-screwnet"
  #acl           = "private"
  force_destroy = true
  versioning {
    enabled = true
  }
  logging {
    target_bucket = aws_s3_bucket.logging_bucket.id
    target_prefix = "logs/cloudfront/"
  }
  tags = var.tags
}

# Add static resource to bucket
resource "aws_s3_bucket_object" "index" {
  bucket       = aws_s3_bucket.cloudfrontbucket.id
  key          = "index.html"
  source       = "index.html"
  content_type = "text/html"
}

# Create policy to attach to bucket to allow only restricted access from cloudfront
data "aws_iam_policy_document" "allow-cloudfront-policy" {
  statement {
    sid       = "AllowCloudFrontaccessS3bucketObject"
    actions   = ["s3:GetObject"]
    effect    = "Allow"
    resources = ["${aws_s3_bucket.cloudfrontbucket.arn}/*"]
    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.oai_cfd.iam_arn]
    }
  }
  statement {
    sid       = "AllowCloudFrontlistS3bucket"
    actions   = ["s3:ListBucket"]
    effect    = "Allow"
    resources = [aws_s3_bucket.cloudfrontbucket.arn]
    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.oai_cfd.iam_arn]
    }
  }
}

resource "aws_s3_bucket_policy" "allow-cloudfront" {
  bucket = aws_s3_bucket.cloudfrontbucket.id
  policy = data.aws_iam_policy_document.allow-cloudfront-policy.json
}

# Allow ALB to write logs to S3
#    resources = ["${aws_s3_bucket.logging_bucket.arn}/AWSLogs/${data.aws_caller_identity.current.account_id}/*"]
data "aws_iam_policy_document" "alb_logging_policy" {
  statement {
    sid       = "AllowPutObjectByALB"
    actions   = ["s3:PutObject"]
    effect    = "Allow"
    resources = ["${aws_s3_bucket.logging_bucket.arn}/${var.lb_log_prefix}/AWSLogs/*"]
    principals {
      type        = "AWS"
      identifiers = ["${data.aws_elb_service_account.wp_alb.arn}"]
    }
  }
  statement {
    sid       = "AWSLogDeliveryWrite"
    actions   = ["s3:PutObject"]
    effect    = "Allow"
    resources = ["${aws_s3_bucket.logging_bucket.arn}/${var.lb_log_prefix}/AWSLogs/*"]
    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }
    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
  }
  statement {
    sid       = "AWSLogDeliveryAclCheck"
    actions   = ["s3:GetBucketAcl"]
    effect    = "Allow"
    resources = [aws_s3_bucket.logging_bucket.arn]
    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }
  }
}

resource "aws_s3_bucket_policy" "allow-alb-logging" {
  bucket = aws_s3_bucket.logging_bucket.id
  policy = data.aws_iam_policy_document.alb_logging_policy.json
}


/*
resource "aws_s3_bucket_policy" "alb_logging_policy" {
  bucket = aws_s3_bucket.logging_bucket.id
  policy = <<POLICYJSON
{
      "Version": "2012-10-17",
      "Id": "ALB-AccessLogs-Policy-01",
      "Statement": [
          {
              "Sid": "Allow-ALB-to-wrtie-logs",
              "Effect": "Allow",
              "Principal": {
                  "AWS": "arn:aws:iam::${data.aws_elb_service_account.wp_alb.id}:root"
              },
              "Action": "s3:PutObject",
              "Resource": "${aws_s3_bucket.logging_bucket.arn}/AWSLogs/${data.aws_caller_identity.current.account_id}/*"
          },
          {
              "Sid": "AWSLogDeliveryWrite",
              "Effect": "Allow",
              "Principal": {
                  "Service": "delivery.logs.amazonaws.com"
              },
              "Action": "s3:PutObject",
              "Resource": "${aws_s3_bucket.logging_bucket.arn}/AWSLogs/${data.aws_caller_identity.current.account_id}/*",
              "Condition": {
                  "StringEquals": {
                      "s3:x-amz-acl": "bucket-owner-full-control"
                  }
              }
          },
          {
              "Sid": "AWSLogDeliveryAclCheck",
              "Effect": "Allow",
              "Principal": {
                  "Service": "delivery.logs.amazonaws.com"
              },
              "Action": "s3:GetBucketAcl",
              "Resource": "${aws_s3_bucket.logging_bucket.arn}"
          }
      ]
  }
POLICYJSON
}
*/
