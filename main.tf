locals {
  app_name     = "vault"
  ingress_host = "${local.app_name}.${var.domain}"
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
      global = {
        tlsDisable = false
      }
      server = {
        extraEnvironmentVars = {
          VAULT_TLSCERT = "/vault/userconfig/${kubernetes_secret.vault_server_cert.metadata[0].name}/tls.crt"
          VAULT_TLSKEY  = "/vault/userconfig/${kubernetes_secret.vault_server_cert.metadata[0].name}/tls.key"
          VAULT_CACERT  = "/vault/userconfig/${kubernetes_secret.vault_server_cert.metadata[0].name}/ca.crt"
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
          tls = [
            {
              secretName = "vault-ingress-cert"
              hosts = [
                local.ingress_host
              ]
            }
          ]
          annotations = jsonencode({
            "kubernetes.io/ingress.class"                                       = "nginx"
            "kubernetes.io/ingress.allow-http"                                  = "false"
            "nginx.ingress.kubernetes.io/backend-protocol"                      = "HTTPS"
            "nginx.ingress.kubernetes.io/force-ssl-redirect"                    = "true"
            "nginx.ingress.kubernetes.io/auth-tls-verify-client"                = "off"
            "nginx.ingress.kubernetes.io/auth-tls-pass-certificate-to-upstream" = "false"
            "nginx.ingress.kubernetes.io/auth-tls-secret"                       = "${var.namespace}/${kubernetes_secret.vault_server_cert.metadata[0].name}"
            "cert-manager.io/cluster-issuer"                                    = var.certificate_issuer
            "external-dns.alpha.kubernetes.io/hostname"                         = local.ingress_host
          })
        }
        serviceAccount = {
          create = false
          name   = kubernetes_service_account.vault-sa.metadata[0].name
        }
        extraVolumes = [
          {
            type = "secret"
            name = kubernetes_secret.vault_server_cert.metadata[0].name
          }
        ]
        ha = {
          enabled  = true
          replicas = var.server_replicas
          config   = <<-EOF
            ui = true
            listener "tcp" {
              tls_disable        = false
              address            = "[::]:8200"
              cluster_address    = "[::]:8201"
              tls_cert_file      = "/vault/userconfig/${kubernetes_secret.vault_server_cert.metadata[0].name}/tls.crt"
              tls_key_file       = "/vault/userconfig/${kubernetes_secret.vault_server_cert.metadata[0].name}/tls.key"
              tls_client_ca_file = "/vault/userconfig/${kubernetes_secret.vault_server_cert.metadata[0].name}/ca.crt"
            }

            storage "dynamodb" {
              ha_enabled = true
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
      }
    )
  ]
}
