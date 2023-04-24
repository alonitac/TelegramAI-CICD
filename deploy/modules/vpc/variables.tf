variable "region" {
  description = "AWS region"
  type = string
}

variable "aws_access_key" {
  description = "AWS access key"
  type = list(string)
}

variable "aws_access_secret" {
  description = "AWS access secret"
  type = list(string)
}