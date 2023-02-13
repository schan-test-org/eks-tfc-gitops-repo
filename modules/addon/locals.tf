locals {
  create_iam_role       = var.eks_addons_info.install && var.eks_addons_info.iam_role.create && var.eks_addons_info.name != "" ? true : false
  create_iam_policy     = local.create_iam_role && try(var.eks_addons_info.iam_role.policy_name, "") != "" ? (local.install_ebs_addon ? (local.use_custom_kms ? true : false) : true) : false
  install_ebs_addon     = var.eks_addons_info.install && var.eks_addons_info.name == "aws-ebs-csi-driver" ? true : false
  create_storage_class  = local.install_ebs_addon && try(var.eks_addons_info.apply_manifest, false) ? true : false
  enable_ebs_encryption = local.install_ebs_addon && try(var.eks_addons_info.enable_encryption, false) ? true : false
  use_custom_kms        = local.enable_ebs_encryption && try(var.eks_addons_info.use_custom_kms, false) ? true : false
  kmsKeyId              = local.use_custom_kms ? "${aws_kms_alias.ebs_kms[0].arn}" : "${format("arn:aws:kms:%s:%s:alias/aws/ebs", var.region, var.account_id)}"
}
