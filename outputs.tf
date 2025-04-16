output "bucket_name" {
  value       = aws_s3_bucket.default.bucket
  description = "The name of the bucket where the site must be uploaded"
  sensitive   = false
}

output "cloudfront_distribution_id" {
  value       = aws_cloudfront_distribution.default.id
  description = "The ID of the CloudFront distribution"
  sensitive   = false
}

output "cloudfront_distribution_domain_name" {
  value       = aws_cloudfront_distribution.default.domain_name
  description = "The domain name of the CloudFront distribution"
  sensitive   = false
}

output "cloudfront_distribution_hosted_zone_id" {
  value       = aws_cloudfront_distribution.default.hosted_zone_id
  description = "The hosted zone ID of the CloudFront distribution"
  sensitive   = false
}

output "pipeline_access_key_id" {
  value       = aws_iam_access_key.pipeline.id
  description = "The ID of the IAM access key for using in a pipeline to deploy the site"
  sensitive   = false
}

output "pipeline_secret_access_key" {
  value       = aws_iam_access_key.pipeline.secret
  description = "The secret of the IAM access key for using in a pipeline to deploy the site"
  sensitive   = true
}