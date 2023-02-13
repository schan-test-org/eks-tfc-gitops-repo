locals {
  common_tags = {
    "project" = var.project
    "env"     = var.env
    "region"  = var.region
    "managed" = "terraform"
  }
}

resource "random_string" "random" {
  length  = 5
  special = false
  upper   = false
}
