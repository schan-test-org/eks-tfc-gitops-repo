############################################
# version of terraform and providers
############################################
terraform {
  cloud {
    organization = "schan-test"

    workspaces {}
  }
}

############################################
# AWS Provider Configuration
############################################
provider "aws" {
  region  = var.aws_region
  # profile = var.aws_profile

  ignore_tags {
    key_prefixes = ["created"]
  }

}

# provider "kubernetes" {
#   cluster_ca_certificate = base64decode(module.eks_cluster.eks_cluster_certificate_authority_data)
#   host                   = module.eks_cluster.eks_cluster_endpoint
#   token                  = data.aws_eks_cluster_auth.cluster.token
# }

provider "kubernetes" {
  cluster_ca_certificate = base64decode(local.eks_cluster_certificate_authority_data)
  host                   = local.eks_endpoint_url
  token                  = local.eks_auth_token
}