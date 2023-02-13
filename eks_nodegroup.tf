module "nodegroup" {
  for_each = var.eks_node_groups
  source   = "./modules/nodegroup"

  project = var.project
  env     = var.env
  region  = local.region

  eks_cluster_name                       = module.eks_cluster.eks_cluster_name
  eks_cluster_version                    = module.eks_cluster.eks_cluster_version
  eks_cluster_endpoint                   = module.eks_cluster.eks_cluster_endpoint
  eks_cluster_certificate_authority_data = module.eks_cluster.eks_cluster_certificate_authority_data

  subnet_id_list         = try(each.value.private_networking, true) ? local.k8s_private_subnet_ids : local.k8s_public_subnet_ids
  key_pair_name          = var.key_pair_name
  vpc_security_group_ids = local.nodegroup_sg_ids

  # before passing node group variables, check the node group variables and identifier
  eks_node_group_info = {
    name                 = each.value.name == "" ? each.key : each.value.name
    capacity_type        = try(each.value.use_spot, false) ? "SPOT" : "ON_DEMAND"
    instance_type        = try(each.value.use_spot, false) ? "" : each.value.instance_type
    instance_types       = try(each.value.use_spot, false) ? each.value.spot_instance_types : []
    instance_volume      = try(each.value.instance_volume, 30)
    desired_size         = try(each.value.desired_size, 1)
    min_size             = try(each.value.min_size, 1)
    max_size             = try(each.value.max_size, 2)
    description          = try(each.value.description, "")
    labels               = try(each.value.labels, {})
    taints               = try(each.value.taints, [])
    kubelet_version      = try(each.value.kubelet_version, "")
    user_data            = try(each.value.user_data_script, "") == "" ? "" : base64encode(file("${path.module}/templates/${each.value.user_data_script}"))
    role_name            = format("%s-%s-nodegroup-role", module.eks_cluster.eks_cluster_name, each.key)
    launch_template_name = format("%s-%s", module.eks_cluster.eks_cluster_name, each.key)
  }

  eks_addons  = var.eks_addons
  common_tags = local.common_tags
}
