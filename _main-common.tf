
############################# main : local #######################################
locals {
  common_tags = merge(var.default_tags, {
    "region"  = var.aws_region
    "project" = var.project
    "env"     = var.env
    "managed" = "terraform"

  })

  vpc_id                 = try(var.vpc_id, "") == "" ? data.terraform_remote_state.vpc.0.outputs.vpc_id : var.vpc_id
  # k8s_private_subnet_ids = length(var.private_subnet_ids) == 0 ? data.terraform_remote_state.network.0.outputs.eks_private_subnet_ids : var.private_subnet_ids
  # k8s_public_subnet_ids  = length(var.public_subnet_ids) == 0 ? data.terraform_remote_state.network.0.outputs.public_subnet_ids : var.public_subnet_ids
  k8s_private_subnet_ids = var.private_subnet_ids
  k8s_public_subnet_ids  = var.public_subnet_ids

  cluster_sg_ids   = try(var.additional_cluster_security_group_ids, [])
  nodegroup_sg_ids = concat([aws_security_group.nodegroup.id], [aws_security_group.shared.id], try(var.additional_nodegroup_security_group_ids, []))

  key_pair_name = var.key_pair_name

  eks_cluster_name         = try(var.eks_cluster_name, "") == "" ? format("%s-eks-%s", var.env, local.resource_postfix) : var.eks_cluster_name
  eks_cluster_version      = var.eks_cluster_version
  public_access_white_list = length(var.public_access_cidrs) > 0 ? var.public_access_cidrs : ["0.0.0.0/0"]

  eks_endpoint_url                       = try(var.eks_endpoint_url, "") == "" ? module.eks_cluster.eks_cluster_endpoint : var.eks_endpoint_url
  eks_cluster_certificate_authority_data = try(var.eks_cluster_certificate_authority_data, "") == "" ? module.eks_cluster.eks_cluster_certificate_authority_data : var.eks_cluster_certificate_authority_data
  eks_auth_token                         = try(var.eks_endpoint_url, "") == "" ? data.aws_eks_cluster_auth.cluster[0].token : data.aws_eks_cluster_auth.existing_cluster[0].token

  sg_name_cluster   = format("%s-cluster/ControlPlaneSG", local.eks_cluster_name)
  sg_name_nodegroup = format("%s-nodegroup/NodeGroupSG", local.eks_cluster_name)
  sg_name_shared    = format("%s-cluster/SharedSG", local.eks_cluster_name)

  resource_postfix   = random_string.random.result
  bastion_private_ip = var.bastion_private_ip
  # bastion_private_ip     = try(data.terraform_remote_state.network.0.outputs.bastion_private_ip, "")

}

############################# main : resource #######################################

resource "random_string" "random" {
  length  = 3
  special = false
  upper   = false
}
