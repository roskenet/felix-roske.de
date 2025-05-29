terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }
  }

  required_version = ">= 1.3.0"
}

provider "aws" {
  region = "us-east-1" # ACM certificates for CloudFront must be in us-east-1
}

provider "aws" {
  alias  = "default"
  region = var.region
}

# 1. Route53 Zone Lookup
data "aws_route53_zone" "selected" {
  name         = var.root_domain
  private_zone = false
}

# 2. ACM Certificate (in us-east-1!)
resource "aws_acm_certificate" "cert" {
  domain_name       = var.domain_name
  validation_method = "DNS"

  subject_alternative_names = [
    var.domain_name
  ]

  lifecycle {
    create_before_destroy = true
  }
}

# 3. DNS Validation Record
resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      type   = dvo.resource_record_type
      record = dvo.resource_record_value
    }
  }

  zone_id = data.aws_route53_zone.selected.zone_id
  name    = each.value.name
  type    = each.value.type
  records = [each.value.record]
  ttl     = 300
}

# 4. Validate the Certificate
resource "aws_acm_certificate_validation" "cert_validated" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
}

# 5. S3 Bucket (Website Content)
resource "aws_s3_bucket" "website" {
  provider = aws.default
  bucket   = var.domain_name

  tags = {
    Name = "WebsiteBucket"
  }
}

resource "aws_s3_bucket_ownership_controls" "website" {
  provider = aws.default
  bucket   = aws_s3_bucket.website.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_public_access_block" "website" {
  provider = aws.default
  bucket   = aws_s3_bucket.website.id

  block_public_acls       = true
  block_public_policy     = false
  ignore_public_acls      = true
  restrict_public_buckets = false
}

# 6. S3 Bucket Policy (Allow CloudFront Access)
resource "aws_s3_bucket_policy" "website_policy" {
  provider = aws.default
  bucket   = aws_s3_bucket.website.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "AllowCloudFrontServicePrincipalReadOnly",
        Effect    = "Allow",
        Principal = {
          Service = "cloudfront.amazonaws.com"
        },
        Action    = ["s3:GetObject"],
        Resource  = ["${aws_s3_bucket.website.arn}/*"],
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = "arn:aws:cloudfront::${data.aws_caller_identity.current.account_id}:distribution/${aws_cloudfront_distribution.website.id}"
          }
        }
      }
    ]
  })
  depends_on = [aws_cloudfront_distribution.website]
}

# 7. CloudFront
data "aws_caller_identity" "current" {}

resource "aws_cloudfront_origin_access_control" "oac" {
  name                              = "WebsiteOAC"
  description                       = "Access to S3 from CloudFront"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "website" {
  origin {
    domain_name = aws_s3_bucket.website.bucket_regional_domain_name
    origin_id   = "s3-origin"

    origin_access_control_id = aws_cloudfront_origin_access_control.oac.id
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "Static site for ${var.domain_name}"
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "s3-origin"

    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  price_class = "PriceClass_100"

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate_validation.cert_validated.certificate_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  aliases = [var.domain_name]
}

# 8. DNS Record for www.felix-roske.de
resource "aws_route53_record" "www" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.website.domain_name
    zone_id                = aws_cloudfront_distribution.website.hosted_zone_id
    evaluate_target_health = false
  }
}
