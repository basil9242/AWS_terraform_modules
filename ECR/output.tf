output "ecr_arn" {
    description = "ECR arn"
    value = aws_ecr_repository.ecr_repository.arn  
}