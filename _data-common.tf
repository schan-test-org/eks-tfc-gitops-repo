############################# data : local #######################################

locals {
  region                        = var.aws_region
  # network_package_bucket_name   = var.backend_s3_bucket_name
  # network_package_bucket_key    = var.infra_network_s3_key
  # network_package_bucket_region = local.region
}

############################# data : aws_caller #######################################
data "aws_caller_identity" "current" {

}
############################# data : k8s #######################################
data "kubernetes_config_map" "aws_auth" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  depends_on = [
    module.nodegroup
  ]
}

data "aws_eks_cluster_auth" "cluster" {
  count = try(var.eks_endpoint_url, "") == "" ? 1 : 0
  name  = module.eks_cluster.eks_cluster_name

  depends_on = [
    module.eks_cluster
  ]
}

data "aws_eks_cluster_auth" "existing_cluster" {
  count = try(var.eks_endpoint_url, "") == "" ? 0 : 1
  name  = module.eks_cluster.eks_cluster_name
}

############################# data : remote #######################################
data "terraform_remote_state" "vpc" {
  count = var.vpc_id == "" ? 1 : 0

  backend = "remote"
  config = {
    organization = "schan-test"
    workspaces = {
      name = "dev-vpc-tfc"
    }
  }
}

data "terraform_remote_state" "network" {
  count = var.vpc_id == "" ? 1 : 0
  # tfstate outputs-list : eks_private_subnet_ids, nat_gateway_ids, public_subnet_ids
  # how to get : data.terraform_remote_state.network.0.outputs.xxx 
  backend = "remote"
  config = {
    organization = "schan-test"
    workspaces = {
      name = "dev-subnet-tfc"
    }
  }
  
}




