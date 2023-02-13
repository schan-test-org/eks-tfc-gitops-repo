resource "aws_launch_template" "nodegroup" {
  name                   = var.eks_node_group_info.launch_template_name
  description            = var.eks_node_group_info.description
  update_default_version = true

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size           = var.eks_node_group_info.instance_volume
      volume_type           = "gp3"
      delete_on_termination = true
    }
  }

  instance_type          = var.eks_node_group_info.capacity_type == "SPOT" ? null : var.eks_node_group_info.instance_type
  key_name               = var.key_pair_name
  vpc_security_group_ids = var.vpc_security_group_ids

  monitoring {
    enabled = true
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 2
  }

  tag_specifications {
    resource_type = "instance"

    tags = merge(
      var.common_tags,
      tomap({ "Name" = var.eks_node_group_info.launch_template_name })
    )
  }

  user_data = var.eks_node_group_info.user_data

  tags = merge(
    var.common_tags,
    tomap({ "Name" = var.eks_node_group_info.name })
  )

  lifecycle {
    create_before_destroy = true
  }
}
