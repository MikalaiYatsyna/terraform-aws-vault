module "records" {
  source = "terraform-aws-modules/route53/aws//modules/records"

  zone_name = data.aws_route53_zone.zone.name
  records = [
    {
      name    = "${local.app_name}.core"
      type    = "CNAME"
      records = [var.lb_url]
      ttl     = 30
    }
  ]
}
