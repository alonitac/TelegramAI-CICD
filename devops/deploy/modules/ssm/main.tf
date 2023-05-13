resource "aws_ssm_parameter" "telegram_secret_token" {
  name        = "/telegram/token/${var.git_branch}"
  description = "telegram secret token"
  type        = "SecureString"
  value       = "${var.telegram_token}"
}