#ACM issued certificate for domain
resource "aws_acm_certificate" "screwnetcert" {
  domain_name               = "screwnet.work"
  subject_alternative_names = ["*.screwnet.work"]
  validation_method         = "DNS"
  tags                      = var.tags
  options {
    certificate_transparency_logging_preference = "ENABLED"
  }
  lifecycle {
    create_before_destroy = true
  }
}
