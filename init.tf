locals {
  tls_path = "/etc/userconfig/tls"
}
resource "aws_secretsmanager_secret" "vault_root_token" {
  name                    = "${var.stack}-vault-root-token"
  recovery_window_in_days = 0
}

# Allow 2 mins for helm to create pod
resource "time_sleep" "vault_release" {
  depends_on      = [helm_release.vault]
  create_duration = "30s"
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
            value = "https://${local.app_name}.${var.namespace}.svc.cluster.local:8200"
          }
          env {
            name  = "VAULT_CAPATH"
            value = "${local.tls_path}/ca.crt"
          }
          env {
            name  = "SECRET_NAME"
            value = aws_secretsmanager_secret.vault_root_token.name
          }
          volume_mount {
            name       = kubernetes_secret.vault_server_cert.metadata[0].name
            mount_path = local.tls_path
          }
        }
        volume {
          name = kubernetes_secret.vault_server_cert.metadata[0].name
          secret {
            secret_name = kubernetes_secret.vault_server_cert.metadata[0].name
          }
        }
      }
    }
  }
}
