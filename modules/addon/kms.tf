resource "aws_kms_key" "ebs_kms" {
  count               = local.use_custom_kms ? 1 : 0
  description         = "KMS key for EBS on EKS"
  policy              = data.template_file.kms_policy[0].rendered
  enable_key_rotation = true

  depends_on = [
    aws_iam_role.addon_service_account_role
  ]
}

resource "aws_kms_alias" "ebs_kms" {
  count         = length(aws_kms_key.ebs_kms) == 0 ? 0 : 1
  name          = format("alias/%s-ebs", var.eks_cluster_name)
  target_key_id = aws_kms_key.ebs_kms[0].key_id
}
