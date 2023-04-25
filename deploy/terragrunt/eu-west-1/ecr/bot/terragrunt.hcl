include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "${find_in_parent_folders()}/../../modules//ecr"
}

inputs = {
  aws_access_key = get_env("AWS_ACCESS_KEY")
  aws_access_secret = get_env("AWS_ACCESS_SECRET")
  region = local.path[0]
}

locals {
    path = split("/", path_relative_to_include())
}
