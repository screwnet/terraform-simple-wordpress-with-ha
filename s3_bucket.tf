# Create a logging bucket to store logs
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
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.cloudfrontbucket.arn}/*"]
    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.oai_cfd.iam_arn]
    }
  }
  statement {
    actions   = ["s3:ListBucket"]
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
