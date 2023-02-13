##############################################################
# Create addon
##############################################################
resource "aws_eks_addon" "addon" {
  count = var.eks_addons_info.install && var.eks_addons_info.name != "" ? 1 : 0

  cluster_name             = var.eks_cluster_name
  addon_name               = var.eks_addons_info.name
  service_account_role_arn = var.eks_addons_info.iam_role.create ? aws_iam_role.addon_service_account_role[0].arn : null
  addon_version            = var.eks_addons_info.version != "" ? var.eks_addons_info.version : null
  # preserve                 = try(var.eks_addons_info.preserve, false)
  resolve_conflicts        = "OVERWRITE"
}
