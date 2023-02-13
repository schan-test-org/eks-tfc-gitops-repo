locals {
  BOOTSTRAPPER       = ["system:bootstrappers", "system:nodes"]
  CLUSTER_ADMIN      = ["system:masters"]
  NODE_USERNAME      = "system:node:{{EC2PrivateDNSName}}"
  ANONYMOUS_USERNAME = "aws:{{AccountID}}:{{SessionName}}"
  ROLE_GROUP_TYPE    = { BOOTSTRAPPER = local.BOOTSTRAPPER, CLUSTER_ADMIN = local.CLUSTER_ADMIN }
  USER_GROUP_TYPE    = { CLUSTER_ADMIN = local.CLUSTER_ADMIN }

  # get node role arns (from input node_groups)
  node_group_role_arns = [for ng in keys(var.eks_node_groups) : format("arn:aws:iam::%s:role/%s-%s-nodegroup-role", data.aws_caller_identity.current.id, var.eks_cluster_name, ng)]

  # validate node roles between exist node group role and input data
  aws_auth_roles = [
    for role in yamldecode(data.kubernetes_config_map.aws_auth.data.mapRoles) :
    {
      rolearn  = role.rolearn
      roletype = "BOOTSTRAPPER"
      username = local.NODE_USERNAME
    }
    if contains(local.node_group_role_arns, role.rolearn)
  ]

  karpenter_role = var.karpenter.enabled ? [
    {
      rolearn  = format("arn:aws:iam::%s:role/%s", data.aws_caller_identity.current.id, try(var.karpenter.role_name, ""))
      roletype = "BOOTSTRAPPER"
      username = local.NODE_USERNAME
    }
  ] : []

  # Reduce duplicate roles and users
  merged_roles = setunion(local.aws_auth_roles, local.karpenter_role, var.rbac_roles)
  mapRoles = [
    for i in local.merged_roles :
    {
      rolearn  = i.rolearn
      username = try(i.username, local.ANONYMOUS_USERNAME)
      groups   = lookup(local.ROLE_GROUP_TYPE, i.roletype, [])
    }
  ]
  mapUsers = [
    for i in var.rbac_users :
    {
      userarn  = i.userarn
      username = try(i.username, local.ANONYMOUS_USERNAME)
      groups   = lookup(local.USER_GROUP_TYPE, i.usertype, [])
    }
  ]
}

# Reconfigure aws auth
resource "kubernetes_config_map_v1_data" "aws_auth" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    mapRoles = length(local.mapRoles) > 0 ? yamlencode(local.mapRoles) : null
    mapUsers = length(local.mapUsers) > 0 ? yamlencode(local.mapUsers) : null
  }

  force = true

  depends_on = [
    module.nodegroup
  ]
}

output "aws_auth" {
  value = kubernetes_config_map_v1_data.aws_auth.data
}
