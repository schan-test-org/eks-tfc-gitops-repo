resource "aws_security_group" "nodegroup" {
  name        = local.sg_name_nodegroup
  description = "Security group for all nodes in the cluster"
  vpc_id      = local.vpc_id

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(
    local.common_tags,
    tomap({
      "Name"                                          = local.sg_name_nodegroup
      "kubernetes.io/cluster/${var.eks_cluster_name}" = "owned"
    })
  )
}

#########################################################
## ingress rules
#########################################################
resource "aws_security_group_rule" "ingress_cluster_to_nodes_https" {
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.nodegroup.id
  source_security_group_id = aws_security_group.cluster.id
  description              = "Allow worker nodes in group management to communicate with control plane (workloads using HTTPS port, commonly used with extension API servers)"
}

resource "aws_security_group_rule" "ingress_cluster_to_nodes_tcp" {
  type                     = "ingress"
  from_port                = 1025
  to_port                  = 65535
  protocol                 = "tcp"
  security_group_id        = aws_security_group.nodegroup.id
  source_security_group_id = aws_security_group.cluster.id
  description              = "Allow worker nodes in group management to communicate with control plane (kubelet and workload TCP ports)"
}

#########################################################
## egress rules
#########################################################
resource "aws_security_group_rule" "egress_recommended" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = aws_security_group.nodegroup.id
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Recommended outbound see: https://docs.aws.amazon.com/general/latest/gr/aws-ip-ranges.html"
}

# Example allow outbounds
# - AWS Service: See https://docs.aws.amazon.com/general/latest/gr/aws-ip-ranges.html
# - Your Service
# - External Service
