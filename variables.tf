variable "applicationName" {
  type        = string
  description = "The name of the application"
}
variable "bucket_name" {
  type        = string
  description = "The name of the S3 bucket to create"
}
variable "fqdn" {
  type        = string
  description = "The FQDN of the CloudFront distribution"
}

variable "minimum_protocol_version" {
  type        = string
  description = "The minimum protocol version for the CloudFront distribution"
  default     = "TLSv1.2_2021"
}

variable "additional_fqdns" {
  type        = list(string)
  description = "A list of additional FQDNs for the CloudFront distribution"
  default     = []
}
variable "hosted_zone_id" {
  type        = string
  description = "The Route 53 hosted zone ID"
}

variable "certificate_arn_us_east_1" {
  type        = string
  description = "The ARN of the ACM certificate in us-east-1"
}

variable "default_root_object" {
  type        = string
  description = "The default root object for the CloudFront distribution"
  default     = "index.html"
}
variable "custom_error_responses" {
  type = list(object({
    error_code            = number
    response_code         = number
    response_page_path    = string
    error_caching_min_ttl = number
  }))
  description = "A list of custom error responses for the CloudFront distribution"
  default = [
    {
      error_code            = 404
      response_code         = 200
      response_page_path    = "/index.html"
      error_caching_min_ttl = 10
    },
    {
      error_code            = 403
      response_code         = 200
      response_page_path    = "/index.html"
      error_caching_min_ttl = 10
    }
  ]
}