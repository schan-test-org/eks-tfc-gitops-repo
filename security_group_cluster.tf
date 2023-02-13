resource "aws_security_group" "cluster" {
  name        = local.sg_name_cluster
  vpc_id      = local.vpc_id
  description = "cluster communication with worker nodes"

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(
    local.common_tags,
    tomap({ "Name" = local.sg_name_cluster })
  )
}

#########################################################
## ingress rules
#########################################################
resource "aws_security_group_rule" "ingress_nodes_to_cluster" {
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.cluster.id
  source_security_group_id = aws_security_group.nodegroup.id
  description              = "HTTPS api from node groups"
}

resource "aws_security_group_rule" "ingress_cluster_for_bastion" {
  count             = local.bastion_private_ip != "" ? 1 : 0
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.cluster.id
  cidr_blocks       = formatlist("%s/32", local.bastion_private_ip)
  description       = "HTTPS from bastion server in VPC"
}

#########################################################
## egress rules
#########################################################
resource "aws_security_group_rule" "egress_cluster_to_nodes" {
  type                     = "egress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.cluster.id
  source_security_group_id = aws_security_group.nodegroup.id
  description              = "Allow control plane to communicate with worker nodes in group management (workloads using HTTPS port, commonly used with extension API servers)"
}

resource "aws_security_group_rule" "egress_cluster" {
  type                     = "egress"
  from_port                = 1025
  to_port                  = 65535
  protocol                 = "tcp"
  security_group_id        = aws_security_group.cluster.id
  source_security_group_id = aws_security_group.nodegroup.id
  description              = "Allow control plane to communicate with worker nodes in group management (random ports for kube-proxy of node groups)"
}
