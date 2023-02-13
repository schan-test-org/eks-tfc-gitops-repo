
# EKS Worker Nodes Resources
# Data source to fetch latest EKS worker AMI

# data "aws_ami" "nodegroup" {
#   filter {
#     name   = "name"
#     values = ["amazon-eks-node-v20210722"]
# 		# values = ["amazon-eks-node-${var.eks_ami_tag}"]
#   }

#   most_recent = true
#   owners      = ["602401143452"] # Amazon EKS AMI Account ID
# }
