resource "aws_ecr_repository" "ecr_repo" {
  name = var.repo_name
  force_delete = true
}