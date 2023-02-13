data "template_file" "ebs_encryption_policy" {
  count    = length(aws_kms_alias.ebs_kms) == 0 ? 0 : 1
  template = file("${path.root}/templates/kms-key-for-encryption-on-ebs.tpl")
  vars = {
    key_alias_arn = "${aws_kms_alias.ebs_kms[0].arn}"
  }

  depends_on = [
    aws_kms_alias.ebs_kms
  ]
}

data "template_file" "kms_policy" {
  count    = local.use_custom_kms ? 1 : 0
  template = file("${path.root}/templates/kms-policy.tpl")
  vars = {
    account_id = "${var.account_id}"
    role_name  = "${aws_iam_role.addon_service_account_role[0].name}"
  }
}
