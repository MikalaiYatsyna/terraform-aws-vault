data "aws_region" "current" {
  provider = aws
}

data "aws_lb" "ingress_lb" {
  count = var.create_ingress ? 1 : 0
  arn = var.lb_arn
}

data "aws_route53_zone" "zone" {
  count = var.create_ingress ? 1 : 0
  name  = var.domain
}

data "aws_eks_cluster" "eks_cluster" {
  name = var.cluster_name
}

data "aws_eks_cluster_auth" "eks_cluster_auth" {
  name = var.cluster_name
}
