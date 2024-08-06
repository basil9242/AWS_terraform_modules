resource "aws_ecr_repository_policy" "ecr_repository_policy" {
  count      = var.ecr_repository_policy_requried ? 1 : 0
  repository = aws_ecr_repository.ecr_repository.name
  policy     = file(var.ecr_policy_json_file)
}