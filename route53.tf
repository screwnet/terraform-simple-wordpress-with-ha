resource "aws_route53_zone" "screwnet" {
  name    = var.domain_name
  comment = "WHOIS owner: nikhil"
  tags    = var.tags
}

# Log group for logging DNS requests
resource "aws_cloudwatch_log_group" "screwnet_work" {
  name              = "/aws/route53/screwnet.work"
  retention_in_days = 90
}

# IAM policy for allowing route53 access created log group
data "aws_iam_policy_document" "r53_query_logging_access" {
  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["arn:aws:logs:*:*:log-group:/aws/route53/*"]
    principals {
      identifiers = ["route53.amazonaws.com"]
      type        = "Service"
    }
  }
}

resource "aws_cloudwatch_log_resource_policy" "r53_query_logging_access" {
  policy_document = data.aws_iam_policy_document.r53_query_logging_access.json
  policy_name     = "r53_query_logging_access"
}

# Enable query logging
resource "aws_route53_query_log" "screwnet_work" {
  depends_on               = [aws_cloudwatch_log_resource_policy.r53_query_logging_access]
  cloudwatch_log_group_arn = aws_cloudwatch_log_group.screwnet_work.arn
  zone_id                  = aws_route53_zone.screwnet.id
}

# Add alias for Cloudfront
resource "aws_route53_record" "test" {
  zone_id = aws_route53_zone.screwnet.zone_id
  name    = "test.screwnet.work"
  type    = "A"
  alias {
    name                   = aws_cloudfront_distribution.static_files.domain_name
    zone_id                = aws_cloudfront_distribution.static_files.hosted_zone_id
    evaluate_target_health = true
  }
}

#Add ACM DNS verification records
resource "aws_route53_record" "cert_validation" {
  name    = aws_acm_certificate.screwnetcert.domain_validation_options.1.resource_record_name
  type    = aws_acm_certificate.screwnetcert.domain_validation_options.1.resource_record_type
  zone_id = aws_route53_zone.screwnet.zone_id
  records = ["${aws_acm_certificate.screwnetcert.domain_validation_options.1.resource_record_value}"]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "screwnetcert" {
  certificate_arn = aws_acm_certificate.screwnetcert.arn
  validation_record_fqdns = [
    "${aws_route53_record.cert_validation.fqdn}"
  ]
}
