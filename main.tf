locals {
  app_name      = "vault"
  ingress_host  = "${local.app_name}.core.${var.domain}"
  chart_repo    = "https://helm.releases.hashicorp.com"
  chart_name    = "vault"
  ssl_cert_secret = "${var.stack}-vault-cert"
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
      global           = {
        tlsDisable = false
      }
      ui = {
        enabled = true
      }
      server = {
        extraEnvironmentVars = {
          VAULT_TLSCERT = "/vault/userconfig/${local.ssl_cert_secret}/tls.crt"
          VAULT_TLSKEY  = "/vault/userconfig/${local.ssl_cert_secret}/tls.key"
        }
        standalone = {
          enabled = false
        }
        ingress = {
          enabled = true
          hosts   = [
            {
              host  = local.ingress_host
              paths = [
                "/"
              ]
            }
          ]
          tls = [
            {
              secretName = local.ssl_cert_secret
              hosts      = [
                local.ingress_host
              ]
            }
          ]
          annotations = jsonencode({
            "kubernetes.io/ingress.class"                    = "nginx"
            "kubernetes.io/ingress.allow-http"               = "false"
            "nginx.ingress.kubernetes.io/force-ssl-redirect" = "true"
            "nginx.ingress.kubernetes.io/ssl-passthrough"    = "true"
            "nginx.ingress.kubernetes.io/backend-protocol"   = "HTTPS"
          })
        }
        serviceAccount = {
          create = false
          name   = kubernetes_service_account.vault-sa.metadata[0].name
        }
        extraVolumes = [
          {
            type = "secret"
            name = local.ssl_cert_secret
          }
        ]
        ha = {
          enabled  = true
          replicas = var.server_replicas
          config   = <<-EOF
            ui = true
            listener "tcp" {
              tls_disable = 0
              address = "[::]:8200"
              cluster_address = "[::]:8201"
              tls_cert_file = "/vault/userconfig/${local.ssl_cert_secret}/tls.crt"
              tls_key_file  = "/vault/userconfig/${local.ssl_cert_secret}/tls.key"
            }

            storage "dynamodb" {
              ha_enabled = "true"
              region     = "${data.aws_region.current.name}"
              table      = "${aws_dynamodb_table.vault-backend.name}"
            }

            seal "awskms" {
              kms_key_id = "${aws_kms_key.vault_unseal_key.id}"
            }
            service_registration "kubernetes" {}
          EOF
        }
      }
    })
  ]
}

