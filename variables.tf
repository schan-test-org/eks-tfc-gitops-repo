############################# main : var #######################################

variable "env" { type = string }
# variable "aws_profile" { type = string }
variable "aws_region" { type = string }
variable "project" { type = string }
variable "default_tags" { type = map(string) }

############################# bknd & vpc & network about : var #######################################

# variable "backend_s3_bucket_name" {}
# variable "infra_network_s3_key" { default = "" }
variable "vpc_id" { type = string }
variable "private_subnet_ids" { default = [] }
variable "public_subnet_ids" { default = [] }
variable "bastion_private_ip" { default = "" }

############################# eks-node : var #######################################
variable "eks_node_groups" {}
variable "additional_nodegroup_security_group_ids" { default = [] }
variable "key_pair_name" {}

############################# eks-cluster : var #######################################
variable "eks_cluster_name" {}
variable "public_access_cidrs" { default = [] }
variable "endpoint_public_access" { type = bool }
variable "endpoint_private_access" { type = bool }

variable "additional_cluster_security_group_ids" { default = [] }
variable "eks_cluster_version" { default = "" }
variable "eks_endpoint_url" { default = "" }
variable "eks_cluster_certificate_authority_data" { default = "" }


variable "eks_addons" {
  # type = object(
  # {
  #   aws_ebs_csi_driver = object({
  #     name              = string
  #     install           = bool
  #     version           = optional(string)
  #     apply_manifest    = optional(bool)
  #     enable_encryption = optional(bool)
  #     use_custom_kms    = optional(bool)
  #     policy_arns       = optional(list(string))
  #     policy_file       = optional(string)
  #   })
  #   aws_node = object({
  #     name        = string
  #     install     = bool
  #     version     = optional(string)
  #     policy_arns = optional(list(string))
  #   })
  #   coredns = object({
  #     name    = string
  #     install = bool
  #     version = optional(string)
  #   })
  #   kube_proxy = object({
  #     name    = string
  #     install = bool
  #     version = optional(string)
  #   })
  # }
  # )

  default = {
    aws_ebs_csi_driver = {
      name              = "aws-ebs-csi-driver"
      install           = false
      version           = ""
      apply_manifest    = false
      enable_encryption = true
      use_custom_kms    = false
      policy_arns = [
        "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
      ]
      policy_file = "kms-key-for-encryption-on-ebs.tpl"
    }
    aws_node = {
      name    = "vpc-cni"
      install = true
      version = ""
      policy_arns = [
        "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
      ]
    }
    coredns = {
      name    = "coredns"
      install = true
      version = ""
    }
    kube_proxy = {
      name    = "kube-proxy"
      install = true
      version = ""
    }
  }

  description = "eks cluster addons options"
}

variable "karpenter" {
  type = object({
    enabled   = bool
    role_name = string
  })
  description = "karpenter role information for setting configmap/aws-auth"
  default = {
    enabled   = false
    role_name = ""
  }
}

variable "rbac_roles" {
  type = list(object({
    roletype = string
    username = string
    rolearn  = string
  }))
  default     = []
  description = "additional roles for setting configmap/aws-auth"

  validation {
    condition     = length([for i in var.rbac_roles : i if contains(["BOOTSTRAPPER", "CLUSTER_ADMIN", ""], i.roletype)]) == length(var.rbac_roles)
    error_message = "Err: roletype is not valid. valid role types are BOOTSTRAPPER|CLUSTER_ADMIN|\"\" "
  }
}

variable "rbac_users" {
  type = list(object({
    usertype = string
    username = string
    userarn  = string
  }))
  default     = []
  description = "additional users for setting configmap/aws-auth"

  validation {
    condition     = length([for i in var.rbac_users : i if contains(["CLUSTER_ADMIN", ""], i.usertype)]) == length(var.rbac_users)
    error_message = "Err: roletype is not valid. valid role types are CLUSTER_ADMIN|\"\" "
  }
}