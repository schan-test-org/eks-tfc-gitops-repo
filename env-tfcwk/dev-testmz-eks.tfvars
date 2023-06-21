########################################
# Common
########################################
project    = "dev-eks-prj"
aws_region = "ap-northeast-2"
env        = "dev"

default_tags = {
  dept = "DEVOPS/TERRAFORM-CLOUD-GITOPS-TESTING"
}

key_pair_name = "eks-t"

########################################
# workspace setting
########################################


########################################
# network setting
########################################
vpc_id             = "vpc-0e8acf616f7d0dd34"
private_subnet_ids = ["subnet-0dea2a38484eed006", "subnet-0515d47ea98e7952e"]
# public_subnet_ids = ["subnet-0fbc809bfc2f2760e", "subnet-09ab27b079a2aa375"]

# vpc_id             = ""
# private_subnet_ids = []

########################################
# eks cluster
########################################
eks_cluster_name        = "deveks-test"
eks_cluster_version     = "1.24"
endpoint_public_access  = true
endpoint_private_access = true
# bastion_private_ip = ""

# cluster_service_ipv4_cidr = "172.20.0.0/16"
# public_access_cidrs = ["0.0.0.0/0"]

rbac_users = [
  {
    userarn  = "arn:aws:iam::524542846721:user/schan-kg"
    username = "schan-kg"
    usertype = "CLUSTER_ADMIN"
  },
  {
    userarn  = "arn:aws:iam::524542846721:user/mz2"
    username = "mz2"
    usertype = "CLUSTER_ADMIN"
  }
]

########################################
# eks node
########################################

eks_node_groups = {
  ops = {
    "name"          = "ops"
    "instance_type" = "t3.medium"
    # "instance_type"   = "m6i.large"
    "instance_volume" = "30"
    "desired_size"    = 2
    "min_size"        = 0
    "max_size"        = 11
    "description"     = "for operations"
    "labels" = {
      "role" = "ops"
    }
    "taints" = []
    # "taints" = [
    #   {
    #     key    = "role"
    #     value  = "ops"
    #     effect = "NO_SCHEDULE"
    #   },
    # ]
  }

  apps = {
    "name"          = "apps"
    "instance_type" = "t3.medium"
    # "instance_type"   = "r6i.xlarge"
    "instance_volume" = "30"
    "desired_size"    = 1
    "min_size"        = 0
    "max_size"        = 12
    "description"     = "for apps"
    "labels" = {
      "role" = "apps"
    }
    "taints" = []
  }

}

eks_addons = {
  aws_node = {
    install = true
    name    = "vpc-cni"
    # version = "v1.11.4-eksbuild.1"
    policy_arns = [
      "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
    ]
  }

  kube_proxy = {
    install = true
    name    = "kube-proxy"
    # version = "v1.23.8-eksbuild.2"
  }

  coredns = {
    install = true
    name    = "coredns"
    # version = "v1.8.7-eksbuild.2"
  }

  aws_ebs_csi_driver = {
    install = true
    name    = "aws-ebs-csi-driver"
    # version           = "v1.11.4-eksbuild.1"
    apply_manifest    = true
    enable_encryption = true
    use_custom_kms    = false
    policy_file       = "kms-key-for-encryption-on-ebs.tpl"
    policy_arns = [
      "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
    ]
  }
}
