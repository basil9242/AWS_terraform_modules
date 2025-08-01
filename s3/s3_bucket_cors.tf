# S3 Bucket CORS Configuration
resource "aws_s3_bucket_cors_configuration" "s3_bucket_cors" {
  count  = var.enable_cors ? 1 : 0
  bucket = aws_s3_bucket.s3_bucket.id

  dynamic "cors_rule" {
    for_each = var.cors_rules
    content {
      allowed_headers = cors_rule.value.allowed_headers
      allowed_methods = cors_rule.value.allowed_methods
      allowed_origins = cors_rule.value.allowed_origins
      expose_headers  = cors_rule.value.expose_headers
      max_age_seconds = cors_rule.value.max_age_seconds
    }
  }
}