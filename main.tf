locals {
  vault_subdomain = "${var.app_name}.${var.stack}"
  vault_host      = "${local.vault_subdomain}.${var.domain}"
}


resource "aws_kms_key" "vault_unseal_key" {
  description = "Vault unseal key"
}
module "vault" {
  source = "app.terraform.io/logistic/vault/helm"
  app_name            = var.app_name
  namespace           = var.tooling_namespace
  ingress_host        = local.vault_host
  ingress_annotations = {
    "kubernetes.io/ingress.class" = "nginx"
  }
  ingress_enabled      = var.create_ingress
  consul_app_name      = var.consul_app_name
  seal                 = <<EOF
                          seal "awskms" {
                            region     = "${var.region}"
                            kms_key_id = "${aws_kms_key.vault_unseal_key.id}"
                          }
                        EOF

  sa_annotations = {
    "eks.amazonaws.com/role-arn"               = module.vault_role.iam_role_arn
    "eks.amazonaws.com/sts-regional-endpoints" = "true"
  }
}

module "records" {
  count  = var.create_ingress ? 1 : 0
  source = "terraform-aws-modules/route53/aws//modules/records"

  zone_name = data.aws_route53_zone.zone[0].name
  records   = [
    {
      name    = local.vault_subdomain
      type    = "CNAME"
      records = [data.aws_lb.ingress_lb[0].dns_name]
      ttl     = 30
    }
  ]
}