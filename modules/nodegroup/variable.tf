variable "project" {
  type        = string
  default     = ""
  description = "project code which used to compose the resource name"
}

variable "env" {
  type        = string
  default     = ""
  description = "environment: dev, stg, qa, prod "
}

variable "region" {
  type        = string
  default     = "ap-northeast-2"
  description = "aws region to build network infrastructure"
}

variable "common_tags" {
  type        = map(any)
  default     = {}
  description = "A map of tags to add to all resources"
}

variable "eks_cluster_name" {
  type        = string
  default     = ""
  description = "eks cluster name"
}

variable "eks_cluster_version" {
  type        = string
  default     = ""
  description = "(Optional) if is not set, eks version will be applied latest version"
}

variable "eks_cluster_endpoint" {
  type        = string
  default     = ""
  description = "eks cluster endpoint"
}

variable "eks_cluster_certificate_authority_data" {
  type        = string
  default     = ""
  description = "eks cluster ca"
}

variable "key_pair_name" {
  type        = string
  default     = ""
  description = "key pair for ssh"
}

variable "subnet_id_list" {
  type        = list(string)
  default     = []
  description = "subent id's list to create eks cluster"
}

variable "security_group_list" {
  type        = list(string)
  default     = []
  description = "security group id's list to create eks cluster"
}

variable "vpc_security_group_ids" {
  type        = list(string)
  default     = []
  description = "security group id's list to create eks cluster"
}

variable "eks_node_group_info" {
  default     = {}
  description = "Settings for creating node groups"
}

variable "eks_addons" {
  default = {}
  description = "Settings for eks addons"
}