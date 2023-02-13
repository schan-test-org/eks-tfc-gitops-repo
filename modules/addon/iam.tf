##############################################################
# Create an IAM Role for Service Account
##############################################################

# Assume role policy
data "aws_iam_policy_document" "addon_assume_role_policy" {
  count = var.eks_addons_info.install && var.eks_addons_info.iam_role.create ? 1 : 0
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(var.iam_oidc_provider.url, "https://", "")}:sub"
      values   = [format("system:serviceaccount:%s:%s", try(var.eks_addons_info.iam_role.namespace, "*"), try(var.eks_addons_info.iam_role.service_account, "*"))]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(var.iam_oidc_provider.url, "https://", "")}:aud"
      values   = ["sts.amazonaws.com"]
    }

    principals {
      identifiers = [var.iam_oidc_provider.arn]
      type        = "Federated"
    }
  }
}

# Create a role for the service account
resource "aws_iam_role" "addon_service_account_role" {
  count = local.create_iam_role ? 1 : 0

  assume_role_policy = data.aws_iam_policy_document.addon_assume_role_policy[0].json
  name               = var.eks_addons_info.iam_role.role_name

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(
    var.common_tags,
    tomap({ "Name" = var.eks_addons_info.iam_role.role_name })
  )
}

# Create a customer policy for the service account
resource "aws_iam_policy" "addon_policy" {
  count = local.create_iam_policy ? 1 : 0

  name        = var.eks_addons_info.iam_role.policy_name
  description = format("addon's policy for %s", var.eks_addons_info.name)
  policy      = local.use_custom_kms ? data.template_file.ebs_encryption_policy[0].rendered : file(var.eks_addons_info.iam_role.policy_file)

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(
    var.common_tags,
    tomap({ "Name" = var.eks_addons_info.iam_role.policy_name })
  )
}

# Attach customer managed policy to created role
resource "aws_iam_role_policy_attachment" "customer_managed_policy_attachment" {
  count = length(aws_iam_policy.addon_policy) > 0 ? 1 : 0

  policy_arn = aws_iam_policy.addon_policy[0].arn
  role       = aws_iam_role.addon_service_account_role[0].name
}

# Attach managed policy to created role
module "aws_managed_policy_attachment" {
  for_each   = local.create_iam_role ? toset(var.eks_addons_info.iam_role.policy_arns) : []
  source     = "./policy_attachment"
  role_name  = local.create_iam_role ? aws_iam_role.addon_service_account_role[0].name : ""
  policy_arn = each.key
}
