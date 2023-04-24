generate "backend" {
  path      = "backend.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
terraform {
  backend "s3" {
    bucket = "tamir-s3-${local.path[0]}"
    key    = "${path_relative_to_include()}/terraform.tfstate"
    region = "${local.path[0]}"
    access_key = ${get_env("AWS_ACCESS_KEY", "")}
    secret_key = ${get_env("AWS_ACCESS_SECRET", "")}
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
    access_key = get_env("AWS_ACCESS_KEY", "")
    secret_key = get_env("AWS_ACCESS_SECRET", "")
  }
}

locals {
    path = split("/", path_relative_to_include())
}

