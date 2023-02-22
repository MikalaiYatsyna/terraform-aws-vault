locals {
  cluster_name = "${var.stack}-eks"
}

data "aws_region" "current" {
  provider = aws
}

data "aws_lb" "ingress_lb" {
  count = var.create_ingress ? 1 : 0
  tags = {
    Name = "${var.stack}-lb"
  }
}

data "aws_route53_zone" "zone" {
  count = var.create_ingress ? 1 : 0
  name  = var.domain
}

data "aws_eks_cluster" "eks_cluster" {
  name = local.cluster_name
}

data "aws_eks_cluster_auth" "eks_cluster_auth" {
  name = local.cluster_name
}
