resource "aws_s3_bucket_website_configuration" "s3_bucket_website_configuration" {
  count  = var.s3_bucket_website_configuration_requried ? aws_s3_bucket.s3_bucket : 0
  bucket = aws_s3_bucket.s3_bucket.id

  index_document {
    suffix = var.s3_website_index_document
  }
  error_document {
    key = var.s3_website_error_document
  }
}