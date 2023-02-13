locals {
  NEED_IAM_ROLE = tomap({
    "vpc-cni"            = true
    "coredns"            = false
    "kube-proxy"         = false
    "aws-ebs-csi-driver" = true
  })
  SERVICE_ACCOUNT = tomap({
    "vpc-cni"            = "aws-node"
    "aws-ebs-csi-driver" = "ebs-csi-controller-sa"
  })
}

/*
  For DaemonSet type Addons
  e.g. vpc-cni, kube-proxy
*/
module "addon_daemonset_type" {
  for_each = var.eks_addons
  source   = "./modules/addon"

  region = local.region

  eks_cluster_name = module.eks_cluster.eks_cluster_name
  eks_addons_info = {
    name              = each.value.name == "vpc-cni" || each.value.name == "kube-proxy" ? each.value.name : ""
    install           = try(each.value.install, true)
    version           = try(each.value.version, "")
    enable_encryption = try(each.value.enable_encryption, false)
    use_custom_kms    = try(each.value.use_custom_kms, false)

    iam_role = {
      create          = lookup(local.NEED_IAM_ROLE, each.value.name, false)
      namespace       = "kube-system"
      service_account = lookup(local.SERVICE_ACCOUNT, each.value.name, "")
      role_name       = format("%s-%s-role", module.eks_cluster.eks_cluster_name, each.value.name)
      policy_arns     = length(try(each.value.policy_arns, [])) == 0 ? [] : each.value.policy_arns
      policy_name     = try(each.value.policy_file, "") == "" ? "" : format("%s-%s-policy", module.eks_cluster.eks_cluster_name, each.value.name)
      policy_file     = try(each.value.policy_file, "") == "" ? "" : "${path.root}/templates/${each.value.policy_file}"
    }
    apply_manifest = try(each.value.apply_manifest, false)
  }
  common_tags = local.common_tags
  iam_oidc_provider = {
    url = module.eks_cluster.oidc_provider_url
    arn = module.eks_cluster.oidc_provider_arn
  }

  depends_on = [
    module.eks_cluster
  ]
}

/*
  For Deployments, Jobs, etc type Addons
  e.g. coredns, aws-ebs-csi-driver
*/
module "addon_others_type" {
  for_each = var.eks_addons
  source   = "./modules/addon"

  region     = local.region
  account_id = data.aws_caller_identity.current.id

  eks_cluster_name = module.eks_cluster.eks_cluster_name
  eks_addons_info = {
    name              = each.value.name == "vpc-cni" || each.value.name == "kube-proxy" ? "" : each.value.name
    install           = try(each.value.install, true)
    version           = try(each.value.version, "")
    enable_encryption = try(each.value.enable_encryption, false)
    use_custom_kms    = try(each.value.use_custom_kms, false)

    iam_role = {
      create          = lookup(local.NEED_IAM_ROLE, each.value.name, false)
      namespace       = "kube-system"
      service_account = lookup(local.SERVICE_ACCOUNT, each.value.name, "")
      role_name       = format("%s-%s-role", module.eks_cluster.eks_cluster_name, each.value.name)
      policy_arns     = length(try(each.value.policy_arns, [])) == 0 ? [] : each.value.policy_arns
      policy_name     = try(each.value.policy_file, "") == "" ? "" : format("%s-%s-policy", module.eks_cluster.eks_cluster_name, each.value.name)
      policy_file     = try(each.value.policy_file, "") == "" ? "" : "${path.root}/templates/${each.value.policy_file}"
    }
    apply_manifest = try(each.value.apply_manifest, false)
  }
  common_tags = local.common_tags
  iam_oidc_provider = {
    url = module.eks_cluster.oidc_provider_url
    arn = module.eks_cluster.oidc_provider_arn
  }

  depends_on = [
    module.nodegroup
  ]
}
