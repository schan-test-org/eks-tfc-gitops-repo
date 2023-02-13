variable "region" {
  description = "aws region to build network infrastructure"
  default     = ""
}

variable "account_id" {
  description = "aws account id"
  default     = ""
}

variable "eks_cluster_name" {
  description = "aws eks cluster name"
  default     = ""
}

variable "common_tags" {
  description = "A map of tags to add to all resources"
  default     = {}
}

variable "eks_addons_info" {
  description = "eks cluster addons options"

  # type = object({
  #   name              = string
  #   version           = optional(string)
  #   install           = bool
  #   apply_manifest    = optional(bool)
  #   preserve          = optional(bool)
  #   enable_encryption = optional(bool)
  #   use_custom_kms    = optional(bool)

  #   iam_role = object({
  #     create          = bool
  #     role_name       = optional(string)
  #     namespace       = optional(string)
  #     policy_arns     = optional(list(string))
  #     policy_file     = optional(string)
  #     policy_name     = optional(string)
  #     service_account = optional(string)
  #   })
  # })

  default = {
    name              = ""
    version           = ""
    install           = false
    apply_manifest    = false
    preserve          = false
    enable_encryption = false
    use_custom_kms    = false
    iam_role = {
      create          = false
      role_name       = ""
      namespace       = "kube-system"
      policy_arns     = []
      policy_file     = ""
      policy_name     = ""
      service_account = ""
    }
  }
}

variable "iam_oidc_provider" {
  description = "IAM oidc provider information for EKS"
  type = object({
    url = string
    arn = string
  })
  default = {
    arn = ""
    url = ""
  }
}
