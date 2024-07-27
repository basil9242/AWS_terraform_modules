output "s3_bucket_arn" {
  value = aws_s3_bucket.s3_bucket.arn
}

output "s3_bucket_kms_arn" {
  value = aws_kms_key.s3_kms.arn
}