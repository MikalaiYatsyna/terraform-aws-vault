module "vault_role" {
  source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

  role_name = "${var.stack}-${local.app_name}-role"
  role_policy_arns = {
    VaultKmsPolicy = aws_iam_policy.vault_kms_policy.arn
  }

  oidc_providers = {
    main = {
      provider_arn               = var.oidc_provider_arn
      namespace_service_accounts = ["${var.namespace}:${local.app_name}-sa"]
    }
  }
}

resource "aws_iam_policy" "vault_kms_policy" {
  name        = "${local.app_name}-policy"
  description = "Vault policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          # IAM
          "iam:GetRole",
          "iam:GetUser",
          # Secret Manager for populating root token
          "secretsmanager:PutSecretValue"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "kubernetes_service_account" "vault-sa" {
  metadata {
    name      = "${local.app_name}-sa"
    namespace = var.namespace
    annotations = {
      "eks.amazonaws.com/role-arn"               = module.vault_role.iam_role_arn
      "eks.amazonaws.com/sts-regional-endpoints" = "true"
    }
  }
  secret {
    name = "${local.app_name}-sa-secret"
  }
  automount_service_account_token = true
}


resource "kubernetes_secret" "sa-token" {
  depends_on = [kubernetes_service_account.vault-sa]
  type       = "kubernetes.io/service-account-token"
  metadata {
    name      = "${kubernetes_service_account.vault-sa.metadata[0].name}-secret"
    namespace = var.namespace
    annotations = {
      "kubernetes.io/service-account.name" = kubernetes_service_account.vault-sa.metadata[0].name
    }
  }
}
