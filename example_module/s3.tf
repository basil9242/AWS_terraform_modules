provider "aws" {
    region = "ap-south-1"
}

module "s3" {
    source = "git::https://github.com/basil9242/AWS_terraform_modules.git//s3"
    bucket_name = "s3-bucket-basil"
    bucket_acl = "public-read"
    s3_bucket_website_configuration_requried = true
    s3_website_index_document = "index.html"
    s3_website_error_document = "error.html"
}