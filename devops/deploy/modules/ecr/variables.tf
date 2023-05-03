variable "repo_name" {
  description = "Hosted AWS VPC for EKS cluster"
  type = string
}

variable "aws_access_key" {
  description = "AWS access key"
  type = string
}

variable "aws_access_secret" {
  description = "AWS access secret"
  type = string
}

variable "region" {
  description = "AWS region"
  type = string
}
