# Returns the URL of the website
output "s3_url" {
  description = "Website URL"
  value = aws_s3_bucket_website_configuration.static_website_bucket.website_endpoint
}

# Returns the ID of the CloudFront distribution for info
output "cloudfront_id" {
  description = "Cloudfront ID"
  value = aws_cloudfront_distribution.s3_distribution.id
}

# Returns the URL of the CloudFront distribution for testing
output "cloudfront_url" {
  description = "Cloudfront URL"
  value = "https://${aws_cloudfront_distribution.s3_distribution.domain_name}"
}

