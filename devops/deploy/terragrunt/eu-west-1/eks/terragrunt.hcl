include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "${find_in_parent_folders()}/../../modules//eks"
}

inputs = {
  vpc_id = dependency.vpc.outputs.vpc_id
  vpc_private_subnets = dependency.vpc.outputs.vpc_private_subnets
}


dependency "vpc" {
  config_path = "../vpc"
}
