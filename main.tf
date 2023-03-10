locals {
  vault_host = "${var.app_name}.${var.domain}"
}

resource "aws_kms_key" "vault_unseal_key" {
  description = "Vault unseal key"
}

module "vault" {
  source       = "app.terraform.io/logistic/vault/helm"
  version      = "0.0.2"
  app_name     = var.app_name
  namespace    = var.tooling_namespace
  ingress_host = local.vault_host
  ingress_annotations = {
    "kubernetes.io/ingress.class" = "nginx"
  }
  ingress_enabled = var.create_ingress
  consul_app_name = var.consul_app_name
  sa_annotations = {
    "eks.amazonaws.com/role-arn"               = module.vault_role.iam_role_arn
    "eks.amazonaws.com/sts-regional-endpoints" = "true"
  }
  seal = <<EOF
          seal "awskms" {
            region     = "${data.aws_region.current.name}"
            kms_key_id = "${aws_kms_key.vault_unseal_key.id}"
          }
        EOF
}

module "records" {
  count  = var.create_ingress ? 1 : 0
  source = "terraform-aws-modules/route53/aws//modules/records"

  zone_name = data.aws_route53_zone.zone[0].name
  records = [
    {
      name    = var.app_name
      type    = "CNAME"
      records = [data.aws_lb.ingress_lb[0].dns_name]
      ttl     = 30
    }
  ]
}
