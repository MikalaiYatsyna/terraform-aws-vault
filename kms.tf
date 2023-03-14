resource "aws_kms_key" "vault_unseal_key" {
  description = "Vault unseal key"
}
