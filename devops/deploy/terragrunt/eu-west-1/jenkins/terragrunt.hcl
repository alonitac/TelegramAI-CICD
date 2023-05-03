include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "${find_in_parent_folders()}/../../modules//jenkins"
}

inputs = merge(local.common_vars.inputs,
{
  vpc_private_subnets = dependency.vpc.outputs.vpc_private_subnets
  vpc_public_subnets  = dependency.vpc.outputs.vpc_public_subnets
  vpc_id  = dependency.vpc.outputs.vpc_id
  region = local.path[0]
  aws_access_key = get_env("AWS_ACCESS_KEY")
  aws_access_secret = get_env("AWS_ACCESS_SECRET")
})

locals {
  path = split("/", path_relative_to_include())
  common_vars = read_terragrunt_config(find_in_parent_folders("envcommon/common.hcl"))
}

dependency "vpc" {
  config_path = "./..//vpc"
}
