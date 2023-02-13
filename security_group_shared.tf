resource "aws_security_group" "shared" {
  name        = local.sg_name_shared
  vpc_id      = local.vpc_id
  description = "cluster communication with worker nodes"

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(
    local.common_tags,
    tomap({ "Name" = local.sg_name_shared })
  )
}

#########################################################
## ingress rules / Shared Security
#########################################################
resource "aws_security_group_rule" "ingress_shared_self" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.shared.id
  source_security_group_id = aws_security_group.shared.id
  description              = "Allow node to communicate with each other"
}

resource "aws_security_group_rule" "ingress_cluster_to_shared" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.shared.id
  source_security_group_id = module.eks_cluster.eks_cluster_security_group_ids.0
  description              = "Allow managed and unmanaged nodes to communicate with each other (all ports)"
}

#########################################################
## ingress rules / Control Plane Security
#########################################################
resource "aws_security_group_rule" "ingress_shared_to_cluster" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  security_group_id        = module.eks_cluster.eks_cluster_security_group_ids.0
  source_security_group_id = aws_security_group.shared.id
  description              = "Allow unmanaged nodes to communicate with control plane (all ports)"
}

#########################################################
## egress rules / Shared Security
#########################################################
resource "aws_security_group_rule" "egress_shared_self" {
  type                     = "egress"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "-1"
  security_group_id        = aws_security_group.shared.id
  source_security_group_id = aws_security_group.shared.id
  description              = "Allow node to communicate with each other"
}

resource "aws_security_group_rule" "egress_shared_to_cluster" {
  type                     = "egress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.shared.id
  source_security_group_id = module.eks_cluster.eks_cluster_security_group_ids.0
  description              = "Allow managed and unmanaged nodes to communicate with each other (all ports)"
}
