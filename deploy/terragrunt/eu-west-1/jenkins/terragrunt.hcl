include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "${find_in_parent_folders()}/../../modules//jenkins"
}

inputs = {
  vpc_private_subnets = dependency.vpc.outputs.vpc_private_subnets
  vpc_public_subnets  = dependency.vpc.outputs.vpc_public_subnets
  vpc_id  = dependency.vpc.outputs.vpc_id
  region = local.path[0]
}

dependency "vpc" {
  config_path = "./..//vpc"
}
