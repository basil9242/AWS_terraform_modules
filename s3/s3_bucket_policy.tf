resource "aws_s3_bucket_policy" "allow_access_for_bucket" {
  count  = var.s3_bucket_policy_requried ? 1 : 0
  bucket = aws_s3_bucket.s3_bucket.id
  policy = file(var.s3_bucket_policy_json_file_path)
}