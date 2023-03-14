resource "aws_secretsmanager_secret" "vault_root_token" {
  name                    = "${var.stack}-vault-root-token"
  recovery_window_in_days = 0
}

# Allow 2 mins for helm to create pod
resource "time_sleep" "vault_release" {
  depends_on      = [helm_release.vault]
  create_duration = "120s"
}

resource "kubernetes_job" "vault_init_job" {
  depends_on = [time_sleep.vault_release]
  timeouts {
    create = "300s"
  }
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
            value = "https://${local.app_name}:8200"
          }
          env {
            name  = "SECRET_NAME"
            value = aws_secretsmanager_secret.vault_root_token.name
          }
        }
      }
    }
  }
}
