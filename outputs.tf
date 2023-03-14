output "vault_token_secret_id" {
  description = "Id of Vault root token secret in AWS Secret Manager"
  sensitive   = true
  value       = aws_secretsmanager_secret.vault_root_token.id
}

output "vault_address" {
  value = "https://${local.ingress_host}"
}
