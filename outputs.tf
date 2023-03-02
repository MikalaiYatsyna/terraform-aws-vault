output "vault_token_secret_id" {
  description = "Id vault root token secret in AWS Secret Manager"
  sensitive   = true
  value       = aws_secretsmanager_secret.vault_root_token.id
}
