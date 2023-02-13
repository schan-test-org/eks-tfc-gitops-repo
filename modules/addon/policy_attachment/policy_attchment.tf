variable "role_name" {
  type    = string
  default = ""
}

variable "policy_arn" {
  type    = string
  default = ""
}

resource "aws_iam_role_policy_attachment" "policy_attachment" {
  count      = var.role_name != "" && var.policy_arn != "" ? 1 : 0
  policy_arn = var.policy_arn
  role       = var.role_name
}
