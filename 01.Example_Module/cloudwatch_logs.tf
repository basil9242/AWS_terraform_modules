provider "aws" {
    region = "ap-south-1"
}

module "log_group" {
    source = "git::https://github.com/basil9242/AWS_terraform_modules.git//cloudwatch_logs"
    cloudwatch_log_group_name ="test"
    logs_retention_in_days = 7
}