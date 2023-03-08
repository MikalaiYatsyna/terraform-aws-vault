## Create an empty secret, which will be populated during vault init
#resource "aws_secretsmanager_secret" "vault_root_token" {
#  name                    = "${var.stack}-vault-root-token"
#  recovery_window_in_days = 0
#}
#
#
#resource "kubernetes_job" "vault_init_job" {
#  depends_on          = [aws_secretsmanager_secret.vault_root_token, helm_release.vault]
#  wait_for_completion = true
#  metadata {
#    name      = "vault-init-job"
#    namespace = var.namespace
#  }
#  spec {
#    backoff_limit = 20
#    template {
#      metadata {
#        name = "vault-init-job"
#      }
#      spec {
#        service_account_name = kubernetes_service_account.vault-sa.metadata[0].name
#        restart_policy       = "OnFailure"
#        container {
#          image_pull_policy = "Always"
#          name              = "init"
#          image             = var.vault_init_image
#          env {
#            name  = "VAULT_ADDR"
#            value = "http://vault:8200"
#          }
#          env {
#            name  = "SECRET_NAME"
#            value = aws_secretsmanager_secret.vault_root_token.name
#          }
#        }
#      }
#    }
#  }
#}
