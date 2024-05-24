## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudfront_distribution.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_distribution) | resource |
| [aws_cloudfront_origin_access_control.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_origin_access_control) | resource |
| [aws_iam_access_key.pipeline](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_access_key) | resource |
| [aws_iam_policy.bucketAccess](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.cloudfront_invalidation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_user.pipeline](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user) | resource |
| [aws_iam_user_policy_attachment.bucketAccess](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_policy_attachment) | resource |
| [aws_iam_user_policy_attachment.cloudFrontInvalidation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_policy_attachment) | resource |
| [aws_route53_record.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_s3_bucket.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_policy.oac_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_applicationName"></a> [applicationName](#input\_applicationName) | The name of the application | `string` | n/a | yes |
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | The name of the S3 bucket to create | `string` | n/a | yes |
| <a name="input_certificate_arn_us_east_1"></a> [certificate\_arn\_us\_east\_1](#input\_certificate\_arn\_us\_east\_1) | The ARN of the ACM certificate in us-east-1 | `string` | n/a | yes |
| <a name="input_custom_error_responses"></a> [custom\_error\_responses](#input\_custom\_error\_responses) | A list of custom error responses for the CloudFront distribution | <pre>list(object({<br>    error_code            = number<br>    response_code         = number<br>    response_page_path    = string<br>    error_caching_min_ttl = number<br>  }))</pre> | <pre>[<br>  {<br>    "error_caching_min_ttl": 10,<br>    "error_code": 404,<br>    "response_code": 200,<br>    "response_page_path": "/index.html"<br>  },<br>  {<br>    "error_caching_min_ttl": 10,<br>    "error_code": 403,<br>    "response_code": 200,<br>    "response_page_path": "/index.html"<br>  }<br>]</pre> | no |
| <a name="input_default_root_object"></a> [default\_root\_object](#input\_default\_root\_object) | The default root object for the CloudFront distribution | `string` | `"index.html"` | no |
| <a name="input_fqdn"></a> [fqdn](#input\_fqdn) | The FQDN of the CloudFront distribution | `string` | n/a | yes |
| <a name="input_hosted_zone_id"></a> [hosted\_zone\_id](#input\_hosted\_zone\_id) | The Route 53 hosted zone ID | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bucket_name"></a> [bucket\_name](#output\_bucket\_name) | The name of the bucket where the site must be uploaded |
| <a name="output_cloudfront_distribution_id"></a> [cloudfront\_distribution\_id](#output\_cloudfront\_distribution\_id) | The ID of the CloudFront distribution |
| <a name="output_pipeline_access_key_id"></a> [pipeline\_access\_key\_id](#output\_pipeline\_access\_key\_id) | The ID of the IAM access key for using in a pipeline to deploy the site |
| <a name="output_pipeline_secret_access_key"></a> [pipeline\_secret\_access\_key](#output\_pipeline\_secret\_access\_key) | The secret of the IAM access key for using in a pipeline to deploy the site |
