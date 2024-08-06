provider "aws" {
    region = "ap-south-1"
}

module "ecr" {
    source = "git::https://github.com/basil9242/AWS_terraform_modules.git//ecr"
    ecr_name = "test"
    ecr_image_tag_mutability = "MUTABLE"
    ecr_repository_policy_requried = true
    ecr_policy_json_file = "./ecr_policy.json"
}