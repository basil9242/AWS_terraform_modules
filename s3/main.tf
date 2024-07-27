#trivy:ignore:AVD-AWS-0089
resource "aws_s3_bucket" "s3_bucket" {
  bucket        = var.bucket_name
  force_destroy = var.bucket_object_destroy
  tags = {
    Name = var.bucket_name
  }
  acl = var.bucket_acl

}

resource "aws_s3_bucket_public_access_block" "s3_bucket_public_access_block" {
  bucket                  = aws_s3_bucket.s3_bucket.id
  block_public_acls       = var.s3_block_public_acls
  block_public_policy     = var.s3_block_public_policy
  restrict_public_buckets = var.s3_restrict_public_buckets
  ignore_public_acls      = var.s3_ignore_public_acls
}

 