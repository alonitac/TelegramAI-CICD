variable "vpc_id" {
  description = "Hosted AWS VPC for EKS cluster"
  type = string
}

variable "region" {
  description = "AWS region"
  type = string
}

variable "scripts_dir" {
  description = "deployment script"
  type = string
}

variable "vpc_private_subnets" {
  description = "AWS VPC assosicated private subnets"
  type = list(string)
}

variable "vpc_public_subnets" {
  description = "AWS VPC assosicated public subnets"
  type = list(string)
}

variable "aws_access_key" {
  description = "AWS access key"
  type = string
}

variable "aws_access_secret" {
  description = "AWS access secret"
  type = string
}