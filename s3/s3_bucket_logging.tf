# S3 Bucket Logging
resource "aws_s3_bucket_logging" "s3_bucket_logging" {
  count  = var.enable_logging ? 1 : 0
  bucket = aws_s3_bucket.s3_bucket.id

  target_bucket = var.logging_target_bucket
  target_prefix = var.logging_target_prefix

  dynamic "target_grant" {
    for_each = var.logging_target_grants
    content {
      grantee {
        id   = target_grant.value.grantee_id
        type = target_grant.value.grantee_type
      }
      permission = target_grant.value.permission
    }
  }
}