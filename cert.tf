resource "kubernetes_manifest" "certificate" {
  depends_on = [module.records]
  manifest = {
    "apiVersion" = "cert-manager.io/v1"
    "kind"       = "Certificate"
    "metadata"   = {
      "name"      = local.ssl_cert_secret
      "namespace" = var.namespace
    }
    "spec" = {
      "secretName" = local.ssl_cert_secret
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
