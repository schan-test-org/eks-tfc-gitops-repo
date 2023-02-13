# Add new default storage class
resource "kubernetes_storage_class" "gp3" {
  count = local.create_storage_class ? 1 : 0

  metadata {
    name = "gp3"
    annotations = {
      "storageclass.kubernetes.io/is-default-class" = "true"
    }
  }
  storage_provisioner = "ebs.csi.aws.com"
  reclaim_policy      = "Delete"
  parameters = {
    "type"                      = "gp3"
    "csi.storage.k8s.io/fstype" = "ext4"
  }
  allow_volume_expansion = "true"
  volume_binding_mode    = "WaitForFirstConsumer"

  depends_on = [
    aws_eks_addon.addon
  ]
}

# Add new storage class for retain
resource "kubernetes_storage_class" "gp3-retain" {
  count = local.create_storage_class ? 1 : 0

  metadata {
    name = "gp3-retain"
    annotations = {
      "storageclass.kubernetes.io/is-default-class" = "false"
    }
  }
  storage_provisioner = "ebs.csi.aws.com"
  reclaim_policy      = "Retain"
  parameters = {
    "type"                      = "gp3"
    "csi.storage.k8s.io/fstype" = "ext4"
  }
  allow_volume_expansion = "true"
  volume_binding_mode    = "WaitForFirstConsumer"

  depends_on = [
    aws_eks_addon.addon
  ]
}

# Remove default annotation from gp2 (kubernetes.io/aws-ebs: no longer supported PROVISIONER)
resource "kubernetes_annotations" "storage_class_gp2" {
  count = local.create_storage_class ? 1 : 0

  api_version = "storage.k8s.io/v1"
  kind        = "StorageClass"
  metadata {
    name = "gp2"
  }
  annotations = {
    "storageclass.kubernetes.io/is-default-class" = "false"
  }

  force = "true"

  depends_on = [
    aws_eks_addon.addon
  ]
}

# Add encrypted storage class
resource "kubernetes_storage_class" "encrypted_storage_class_gp3" {
  count = local.create_storage_class && local.enable_ebs_encryption ? 1 : 0

  metadata {
    name = "encrypted-gp3"
    annotations = {
      "storageclass.kubernetes.io/is-default-class" = "false"
    }
  }
  storage_provisioner = "ebs.csi.aws.com"
  reclaim_policy      = "Delete"
  parameters = {
    "type"                      = "gp3"
    "csi.storage.k8s.io/fstype" = "ext4"
    "encrypted"                 = "'true'"
    "kmsKeyId"                  = "${local.kmsKeyId}"
  }
  allow_volume_expansion = "true"
  volume_binding_mode    = "WaitForFirstConsumer"

  depends_on = [
    aws_eks_addon.addon
  ]
}
