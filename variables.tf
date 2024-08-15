# Server region
variable "aws_region" {
  description = "Set AWS Server"
  default = "eu-central-1"
}

# Bucket name
variable "s3_bucket_name" {
  description = "Name of the S3 bucket"
  default = "mohsen-matrix"
}

# The html main file
variable "index_main" {
  description = "The home page code name"
  default = "main.html"
}

# The html error file
variable "error_main" {
  description = "The home page code name"
  default = "error.html"
}

# Giving the origin bucket an id
variable "s3_origin_id" {
  description = "ID for the S3 origin"
  default = "matrix-origin"
}

# Defining the cache behavior
variable "cache_behavior" {
  description = "Cache behavior for the CloudFront distribution"
  default = {
    cache_policy_id = "32481bc3-b11c-4895-b301-894cf87662c5"
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods = ["GET", "HEAD"]
    cached_methods = ["GET", "HEAD"]
  }
}
