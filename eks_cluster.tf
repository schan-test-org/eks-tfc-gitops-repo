module "eks_cluster" {
  source = "./modules/cluster"

  project = var.project
  env     = var.env
  region  = local.region

  eks_cluster_name    = local.eks_cluster_name
  eks_cluster_version = var.eks_cluster_version

  subnet_id_list      = concat(local.k8s_private_subnet_ids, local.k8s_public_subnet_ids)
  security_group_list = concat([aws_security_group.cluster.id], local.cluster_sg_ids)

  endpoint_public_access  = var.endpoint_public_access
  endpoint_private_access = var.endpoint_private_access

  public_access_cidrs = local.public_access_white_list

  common_tags = local.common_tags
}

output "eks_cluster_name" {
  value = module.eks_cluster.eks_cluster_name
}

output "eks_cluster_version" {
  value = module.eks_cluster.eks_cluster_version
}

output "eks_cluster_endpoint" {
  value = module.eks_cluster.eks_cluster_endpoint
}

output "eks_cluster_certificate_authority_data" {
  value = module.eks_cluster.eks_cluster_certificate_authority_data
}

output "eks_oidc_provider_arn" {
  value = module.eks_cluster.oidc_provider_arn
}

output "eks_oidc_provider_url" {
  value = module.eks_cluster.oidc_provider_url
}

output "eks_cluster_security_group_ids" {
  value = module.eks_cluster.eks_cluster_security_group_ids
}

output "eks_cluster_info" {
  value = module.eks_cluster.eks_cluster_info
}
