resource "aws_eks_node_group" "nodegroup" {
  cluster_name = var.eks_cluster_name

  node_group_name = var.eks_node_group_info.name
  node_role_arn   = aws_iam_role.nodegroup.arn
  subnet_ids      = var.subnet_id_list
  version         = var.eks_node_group_info.kubelet_version == "" ? var.eks_cluster_version : var.eks_node_group_info.kubelet_version

  capacity_type  = var.eks_node_group_info.capacity_type
  instance_types = var.eks_node_group_info.capacity_type == "SPOT" ? var.eks_node_group_info.instance_types : null

  scaling_config {
    desired_size = var.eks_node_group_info.desired_size
    min_size     = var.eks_node_group_info.min_size
    max_size     = var.eks_node_group_info.max_size
  }

  launch_template {
    name    = aws_launch_template.nodegroup.name
    version = aws_launch_template.nodegroup.default_version
  }

  labels = var.eks_node_group_info.labels

  dynamic "taint" {
    for_each = var.eks_node_group_info.taints

    content {
      key    = taint.value["key"]
      value  = taint.value["value"]
      effect = taint.value["effect"]
    }
  }

  tags = merge(
    var.common_tags,
    tomap({ "Name" = var.eks_node_group_info.name })
  )

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [scaling_config[0].desired_size]
  }

  depends_on = [
    aws_iam_role.nodegroup,
    aws_launch_template.nodegroup,
  ]
}
