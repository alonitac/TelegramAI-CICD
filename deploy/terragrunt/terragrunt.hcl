generate "backend" {
  path      = "backend.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
terraform {
  backend "s3" {
    bucket = "tamir-s3-${local.path[0]}"
    key    = "${path_relative_to_include()}/terraform.tfstate"
    region = "${local.path[0]}"
    access_key = ""
    secret_key = ""
  }
}
EOF
}

remote_state {
  backend = "s3"
  config = {
    bucket         = "tamir-s3-${local.path[0]}"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = "${local.path[0]}"
    dynamodb_table = "my-lock-table"
    access_key = ""
    secret_key = ""
  }
}

locals {
    path = split("/", path_relative_to_include())
}

