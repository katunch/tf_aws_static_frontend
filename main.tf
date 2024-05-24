terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5"
    }
  }
}

resource "aws_s3_bucket" "default" {
  bucket = var.bucket_name
}

# IAM Policy for S3 Bucket Writes
resource "aws_iam_policy" "bucketAccess" {
  name        = "${var.applicationName}-bucket-access"
  description = "Allow access to ${var.bucket_name}"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:DeleteObject",
          "s3:PutObject",
          "s3:GetObject",
          "s3:ListBucket"
        ],
        Resource = [
          aws_s3_bucket.default.arn,
          "${aws_s3_bucket.default.arn}/*"
        ]
      }
    ]
  })
}

# cloudfront distribution 
resource "aws_cloudfront_distribution" "default" {
  depends_on = [aws_cloudfront_origin_access_control.default, aws_s3_bucket.default]
  origin {
    domain_name              = aws_s3_bucket.default.bucket_regional_domain_name
    origin_id                = aws_s3_bucket.default.bucket
    origin_access_control_id = aws_cloudfront_origin_access_control.default.id
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "${var.applicationName} CloudFront Distribution"
  default_root_object = "index.html"
  aliases             = [var.fqdn]

  default_cache_behavior {
    allowed_methods        = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods         = ["GET", "HEAD", "OPTIONS"]
    target_origin_id       = aws_s3_bucket.default.bucket
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn = var.certificate_arn_us_east_1
    ssl_support_method  = "sni-only"
  }

  dynamic "custom_error_response" {
    for_each = var.custom_error_responses
    content {
      error_code            = custom_error_response.value.error_code
      response_code         = custom_error_response.value.response_code
      response_page_path    = custom_error_response.value.response_page_path
      error_caching_min_ttl = custom_error_response.value.error_caching_min_ttl
    }
  }
}

resource "aws_cloudfront_origin_access_control" "default" {
  name                              = "${var.applicationName}-oac"
  description                       = "${var.applicationName} origin access control for ${var.bucket_name} bucket"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

## bucket policy for origin access
resource "aws_s3_bucket_policy" "oac_policy" {
  depends_on = [aws_cloudfront_distribution.default, aws_s3_bucket.default]
  bucket     = aws_s3_bucket.default.bucket
  policy = jsonencode({
    Version = "2012-10-17",
    Id      = "PolicyForCloudFrontPrivateContent"
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          "Service" : "cloudfront.amazonaws.com"
        },
        Action   = "s3:GetObject",
        Resource = "${aws_s3_bucket.default.arn}/*",
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = aws_cloudfront_distribution.default.arn
          }
        }
      }
    ]
  })
}

## route53 record
resource "aws_route53_record" "default" {
  zone_id = var.hosted_zone_id
  name    = var.fqdn
  type    = "A"
  alias {
    name                   = aws_cloudfront_distribution.default.domain_name
    zone_id                = aws_cloudfront_distribution.default.hosted_zone_id
    evaluate_target_health = false
  }
  depends_on = [aws_cloudfront_distribution.default]
}

## IAM Policy to allow CloudFront invalidation
resource "aws_iam_policy" "cloudfront_invalidation" {
  name        = "${var.applicationName}-cloudfront-invalidate"
  description = "Allow CloudFront invalidation of ${var.applicationName}"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "cloudfront:CreateInvalidation",
          "cloudfront:GetInvalidation",
          "cloudfront:ListInvalidations"
        ],
        Resource = aws_cloudfront_distribution.default.arn
      }
    ]
  })
}

## Pipeline IAM User
resource "aws_iam_user" "pipeline" {
  name = "${var.applicationName}-pipeline"
  path = "/${var.applicationName}/"
}

resource "aws_iam_access_key" "pipeline" {
  user = aws_iam_user.pipeline.name
}

resource "aws_iam_user_policy_attachment" "bucketAccess" {
  user       = aws_iam_user.pipeline.name
  policy_arn = aws_iam_policy.bucketAccess.arn
}

resource "aws_iam_user_policy_attachment" "cloudFrontInvalidation" {
  user       = aws_iam_user.pipeline.name
  policy_arn = aws_iam_policy.cloudfront_invalidation.arn
}