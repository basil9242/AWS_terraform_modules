output "s3_bucket_id" {
  description = "Name of the S3 bucket"
  value       = aws_s3_bucket.s3_bucket.id
}

output "s3_bucket_arn" {
  description = "ARN of the S3 bucket"
  value       = aws_s3_bucket.s3_bucket.arn
}

output "s3_bucket_domain_name" {
  description = "Domain name of the S3 bucket"
  value       = aws_s3_bucket.s3_bucket.bucket_domain_name
}

output "s3_bucket_regional_domain_name" {
  description = "Regional domain name of the S3 bucket"
  value       = aws_s3_bucket.s3_bucket.bucket_regional_domain_name
}

output "s3_bucket_hosted_zone_id" {
  description = "Route 53 Hosted Zone ID for the S3 bucket"
  value       = aws_s3_bucket.s3_bucket.hosted_zone_id
}

output "s3_bucket_region" {
  description = "AWS region of the S3 bucket"
  value       = aws_s3_bucket.s3_bucket.region
}

output "s3_bucket_website_endpoint" {
  description = "Website endpoint of the S3 bucket"
  value       = var.s3_bucket_website_configuration_required ? aws_s3_bucket_website_configuration.s3_bucket_website_configuration[0].website_endpoint : null
}

output "s3_bucket_kms_key_id" {
  description = "KMS key ID used for S3 bucket encryption"
  value       = aws_kms_key.s3_kms.id
}

output "s3_bucket_kms_arn" {
  description = "KMS key ARN used for S3 bucket encryption"
  value       = aws_kms_key.s3_kms.arn
}