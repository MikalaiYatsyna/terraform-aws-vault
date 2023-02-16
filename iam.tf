module "vault_role" {
  source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

  role_name                              = "${var.stack}-${var.app_name}-role"
  role_policy_arns = {
    VaultKmsPolicy = aws_iam_policy.vault_kms_policy.arn
  }

  oidc_providers = {
    main = {
      provider_arn               = data.terraform_remote_state.eks.outputs.oidc_provider_arn
      namespace_service_accounts = ["${var.tooling_namespace}:${var.app_name}-sa"]
    }
  }

  tags = {
    stack     = var.stack
    managedBy = "terraform"
  }
}

resource "aws_iam_policy" "vault_kms_policy" {
  name        = "${var.app_name}-policy"
  description = "Vault KMS policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:DescribeKey",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}