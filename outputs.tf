output "vault_token_secret_id" {
  description = "Id of Vault root token secret in AWS Secret Manager"
  sensitive   = true
  value       = aws_secretsmanager_secret.vault_root_token.id
}

output "vault_address" {
  description = "Vault address"
  value = "https://${local.ingress_host}"
}

output "vault_sa" {
  description = "Vault service account name"
  value = kubernetes_service_account.vault-sa.metadata[0].name
}

output "vault_server_cert_secret_name" {
  value = kubernetes_secret.vault_server_cert.metadata[0].name
}
