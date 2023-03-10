resource "aws_secretsmanager_secret" "vault_root_token" {
  name                    = "${var.stack}-vault-root-token"
  recovery_window_in_days = 0
}

# Allow 1 min for Vault pod to be created before running init
resource "time_sleep" "vault_deploy" {
  create_duration = "60s"
}

resource "kubernetes_job" "vault_init_job" {
  depends_on          = [aws_secretsmanager_secret.vault_root_token, helm_release.vault, time_sleep.vault_deploy]
  wait_for_completion = true
  metadata {
    name      = "vault-init-job"
    namespace = var.namespace
  }
  spec {
    backoff_limit = 20
    template {
      metadata {
        name = "vault-init-job"
      }
      spec {
        service_account_name = kubernetes_service_account.vault-sa.metadata[0].name
        restart_policy       = "OnFailure"
        container {
          image_pull_policy = "Always"
          name              = "init"
          image             = var.vault_init_image
          env {
            name  = "VAULT_ADDR"
            value = "https://vault:8200"
          }
          env {
            name  = "SECRET_NAME"
            value = aws_secretsmanager_secret.vault_root_token.name
          }
          env {
            name = "CERTS"
            value = ""
          }
        }
      }
    }
  }
}
