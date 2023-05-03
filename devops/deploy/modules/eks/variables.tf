variable "vpc_id" {
  description = "Hosted AWS VPC for EKS cluster"
  type = string
}

variable "vpc_private_subnets" {
  description = "AWS VPC assosicated private subnets"
  type = list(string)
}