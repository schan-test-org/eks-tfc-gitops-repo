resource "aws_eks_cluster" "cluster" {
  name     = var.eks_cluster_name
  version  = var.eks_cluster_version
  role_arn = aws_iam_role.cluster.arn

  enabled_cluster_log_types = var.log_types

  vpc_config {
    security_group_ids      = var.security_group_list
    subnet_ids              = var.subnet_id_list
    endpoint_private_access = var.endpoint_private_access
    endpoint_public_access  = var.endpoint_public_access
    public_access_cidrs     = var.public_access_cidrs
  }

  tags = merge(
    var.common_tags,
    tomap({ "Name" = var.eks_cluster_name })
  )

  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.AmazonEKSVPCResourceController
  ]
}

output "eks_cluster_name" {
  value = aws_eks_cluster.cluster.name
}

output "eks_cluster_version" {
  value = aws_eks_cluster.cluster.version
}

output "eks_cluster_endpoint" {
  value = aws_eks_cluster.cluster.endpoint
}

output "eks_cluster_certificate_authority_data" {
  value = aws_eks_cluster.cluster.certificate_authority[0].data
}

output "eks_cluster_security_group_ids" {
  value = [aws_eks_cluster.cluster.vpc_config.0.cluster_security_group_id, try(aws_eks_cluster.cluster.vpc_config.0.security_group_ids, "")]
}

output "eks_cluster_info" {
  value = aws_eks_cluster.cluster
}
