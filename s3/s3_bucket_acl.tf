# S3 Bucket ACL (separate resource as per AWS provider v4+ requirements)
resource "aws_s3_bucket_acl" "s3_bucket_acl" {
  count      = var.enable_bucket_acl ? 1 : 0
  bucket     = aws_s3_bucket.s3_bucket.id
  acl        = var.bucket_acl
  depends_on = [aws_s3_bucket_ownership_controls.s3_bucket_ownership]
}

# S3 Bucket Ownership Controls
resource "aws_s3_bucket_ownership_controls" "s3_bucket_ownership" {
  bucket = aws_s3_bucket.s3_bucket.id

  rule {
    object_ownership = var.object_ownership
  }
}