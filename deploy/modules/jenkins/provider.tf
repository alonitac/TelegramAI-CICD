terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region     = "eu-west-1"
  access_key = "AKIA2GMYABLLFS7ESYFF"
  secret_key = "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"
}