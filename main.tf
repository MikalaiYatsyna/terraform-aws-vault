locals {
  app_name     = "vault"
  ingress_host = "${local.app_name}.core.${var.domain}"
  chart_repo   = "https://helm.releases.hashicorp.com"
  chart_name   = "vault"
}

resource "helm_release" "vault" {
  repository        = local.chart_repo
  chart             = local.chart_name
  name              = local.app_name
  namespace         = var.namespace
  dependency_update = true
  atomic            = true

  values = [
    yamlencode({
      fullnameOverride = local.app_name
      server = {
        extraEnvironmentVars = {
          VAULT_ADDR = "http://0.0.0.0:8200"
        }
        ingress = {
          enabled = true
          hosts = [
            {
              host = local.ingress_host
              paths = [
                "/"
              ]
            }
          ]
          annotations = jsonencode({
            "kubernetes.io/ingress.class" = "nginx"
          })
        }
        serviceAccount = {
          create = false
          name   = kubernetes_service_account.vault-sa.metadata[0].name
        }
        ha = {
          enabled  = true
          replicas = var.server_replicas
          config   = <<-EOF
            ui = true

            service_registration "kubernetes" {}

            listener "tcp" {
              tls_disable = 1
              address = "[::]:8200"
              cluster_address = "[::]:8201"
            }

            storage "dynamodb" {
              ha_enabled = "true"
              region     = "${data.aws_region.current.name}"
              table      = "${aws_dynamodb_table.vault-backend.name}"
            }

            seal "awskms" {
              kms_key_id = "${aws_kms_key.vault_unseal_key.id}"
            }
          EOF
        }
      }
    })
  ]
}

