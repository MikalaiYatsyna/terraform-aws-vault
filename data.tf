data "aws_region" "current" {
  provider = aws
}

data "aws_route53_zone" "zone" {
  name = var.domain
}

data "aws_eks_cluster" "eks_cluster" {
  name = var.cluster_name
}

data "aws_eks_cluster_auth" "eks_cluster_auth" {
  name = var.cluster_name
}

data "aws_secretsmanager_secret_version" "vault_root_token" {
  depends_on = [kubernetes_job.vault_init_job]
  secret_id  = aws_secretsmanager_secret.vault_root_token.id
}
