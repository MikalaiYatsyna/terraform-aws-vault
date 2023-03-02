resource "kubernetes_manifest" "certificate" {
  manifest = {
    "apiVersion" = "cert-manager.io/v1"
    "kind"       = "Certificate"
    "metadata"   = {
      "name"      = local.ssl_cert_name
      "namespace" = var.namespace
    }
    "spec" = {
      "secretName" = local.ssl_cert_name
#       Add domain name so init container can fire a request
      "dnsNames"   = [local.ingress_host]
      "issuerRef"  = {
        "name"  = var.certificate_issuer
        "kind"  = "ClusterIssuer"
        "group" = "cert-manager.io"
      }
      "usages" : ["server auth", "client auth"]
    }
  }
}

# Allow 2 mins to solve challlenge and provision certificate
resource "time_sleep" "cert_provision" {
  create_duration = "120s"
  depends_on      = [kubernetes_manifest.certificate]
}
