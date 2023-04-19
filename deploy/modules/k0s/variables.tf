variable "vpc_id" {
  description = "Hosted AWS VPC for EKS cluster"
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