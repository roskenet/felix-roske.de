terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.4"
}

provider "aws" {
  region = "eu-central-1"  # anpassen, falls nötig
}

data "aws_route53_zone" "main" {
  name         = "felixroske.de."
  private_zone = false
}

resource "aws_acm_certificate" "cert" {
  domain_name       = "www.felixroske.de"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      type   = dvo.resource_record_type
      record = dvo.resource_record_value
    }
  }

  zone_id = data.aws_route53_zone.main.zone_id
  name    = each.value.name
  type    = each.value.type
  ttl     = 60
  records = [each.value.record]
}

resource "aws_acm_certificate_validation" "cert_validation" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
}

resource "aws_kms_key" "apprunner_key" {
  description             = "KMS key for AppRunner service encryption"
  deletion_window_in_days = 7
}

resource "aws_apprunner_auto_scaling_configuration_version" "apprunner_auto_scaling" {
  auto_scaling_configuration_name = "polonium-auto-scaling"

  max_concurrency = 100
  max_size        = 5
  min_size        = 1
}

resource "aws_apprunner_service" "service" {
  service_name = "polonium-service"

source_configuration {
  auto_deployments_enabled = false
  image_repository {
    image_identifier      = "public.ecr.aws/m9p5w9v9/roskenet/polonium:latest"
    image_repository_type = "ECR_PUBLIC"
    image_configuration {
      port = "8080"
    }
  }
}

  instance_configuration {
    cpu    = "1024"
    memory = "2048"
  }

  encryption_configuration {
    kms_key = aws_kms_key.apprunner_key.arn
  }

  auto_scaling_configuration_arn = aws_apprunner_auto_scaling_configuration_version.apprunner_auto_scaling.arn
}

resource "aws_apprunner_custom_domain_association" "custom_domain" {
  service_arn          = aws_apprunner_service.service.arn
  domain_name          = "www.felixroske.de"
  enable_www_subdomain = false
}

resource "aws_route53_record" "www" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "www.felixroske.de"
  type    = "CNAME"
  ttl     = 300
  records = [aws_apprunner_service.service.service_url]
}
