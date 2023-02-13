variable "project" {
  description = "project code which used to compose the resource name"
  default     = ""
}

variable "env" {
  description = "environment: dev, stg, qa, prod "
  default     = ""
}

variable "region" {
  description = "aws region to build network infrastructure"
  default     = ""
}

variable "common_tags" {
  description = "A map of tags to add to all resources"
  default     = {}
}

variable "vpc_id" {
  type        = string
  default     = ""
  description = "vpc id"
}

variable "eks_cluster_name" {
  description = "eks cluster name"
  default     = ""
}

variable "eks_cluster_version" {
  type        = string
  default     = ""
  description = "(Optional) if is not set, eks version will be applied latest version"
}

variable "public_access_cidrs" {
  type        = list(string)
  default     = []
  description = "white list to access eks cluster"
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

variable "endpoint_public_access" {
  type        = bool
  default     = true
}

variable "endpoint_private_access" {
  type        = bool
  default     = true
}

variable "log_types" {
  type = list(string)
  default = ["api","audit","authenticator","controllerManager","scheduler"]

}
