resource "aws_secretsmanager_secret_version" "example" {
  secret_id     = "telegramToken${var.git_branch}TF"
  secret_string = "${var.telegram_token}"
}