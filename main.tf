# Sets server
provider "aws" {
  region = var.aws_region
}

# Creats the bucket
resource "aws_s3_bucket" "s3bucket" {
  bucket = var.s3_bucket_name 
}

# Configurs the bucket to serve as a static website and specifies the html files
resource "aws_s3_bucket_website_configuration" "static_website_bucket" {
  bucket = aws_s3_bucket.s3bucket.id
  
  index_document {
    suffix = var.index_main
  }
  error_document {
    key = var.error_main
  }
}

# Configurs the ownership controls and rules for the bucket
resource "aws_s3_bucket_ownership_controls" "static_website_bucket" {
  bucket = aws_s3_bucket.s3bucket.id
  
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# Allowing public access to the bucket
resource "aws_s3_bucket_public_access_block" "static_website_bucket" {
  bucket = aws_s3_bucket.s3bucket.id

  block_public_acls = false
  block_public_policy = false
  ignore_public_acls = false
  restrict_public_buckets = false
}

# Makes sure the ownership controls and public access is configured and the public can only read the website
resource "aws_s3_bucket_acl" "static_website_bucket" {
  depends_on = [
    aws_s3_bucket_ownership_controls.static_website_bucket,
    aws_s3_bucket_public_access_block.static_website_bucket,
  ]

  bucket = aws_s3_bucket.s3bucket.id
  acl = "public-read"
}

# Configurs the bucket policy for public read access
resource "aws_s3_bucket_policy" "s3_bucket_policy" {
  bucket = aws_s3_bucket.s3bucket.bucket

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid = "PublicReadGetObject"
        Effect = "Allow"
        Principal = "*"
        Action = "s3:GetObject"
        Resource = [
          aws_s3_bucket.s3bucket.arn,
          "${aws_s3_bucket.s3bucket.arn}/*"
        ]
      }
    ]
  })
}

# Uploading the codes
resource "aws_s3_object" "website_file" {
  bucket = aws_s3_bucket.s3bucket.id
  for_each = fileset("files/", "**/*.*")
  key = each.value
  source = "files/${each.value}"
  content_type = each.value
}

# Defines a local variable that stores the bucket id
locals {
  s3_origin_id = var.s3_origin_id
}

# Creates an AWS CloudFront distribution
resource "aws_cloudfront_distribution" "s3_distribution" {
  # Makes sure the bucket exists 
  depends_on = [aws_s3_bucket.s3bucket]

  # Defines the origin of the distribution
  origin {
    domain_name = aws_s3_bucket.s3bucket.bucket_regional_domain_name
    origin_id = local.s3_origin_id
  }

  # Enables the distribution with IPV6 and defines the root for the cache
  enabled = true
  is_ipv6_enabled = true
  default_root_object = var.index_main

  # Defines the viewer certificate
  viewer_certificate {
    cloudfront_default_certificate = true
  }

  # Allowes access from all locations
  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations = []
    }
  }
  
  # Defines the default cache behavior
  default_cache_behavior {
    cache_policy_id = var.cache_behavior.cache_policy_id
    viewer_protocol_policy = var.cache_behavior.viewer_protocol_policy
    allowed_methods = var.cache_behavior.allowed_methods
    cached_methods = var.cache_behavior.cached_methods
    target_origin_id = local.s3_origin_id
  }
}