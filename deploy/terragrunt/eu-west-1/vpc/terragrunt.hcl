include "root" {
  path = find_in_parent_folders()
}

locals {
    path = split("/", path_relative_to_include())
}

terraform {
  source = "${find_in_parent_folders()}/../../modules//vpc"
}




inputs = {
  aws_access_key = get_env("AWS_ACCESS_KEY", "")
  aws_secret_key = get_env("AWS_ACCESS_SECRET", "")
  region = local.path[0]
}
