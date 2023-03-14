resource "kubernetes_manifest" "certificate" {
  depends_on = [data.aws_route53_zone.zone]
  manifest   = {
    "apiVersion" = "cert-manager.io/v1"
    "kind"       = "Certificate"
    "metadata"   = {
      "name"      = local.ssl_cert_secret
      "namespace" = var.namespace
    }
    "spec" = {
      "secretName" = local.ssl_cert_secret
      privateKey   = {
        "algorithm" = "RSA"
        "encoding"  = "PKCS1"
        "size"      = "2048"
      }
      "dnsNames" = [
        local.ingress_host,
        "www.${local.ingress_host}"
      ]
      "issuerRef" = {
        "name" = var.certificate_issuer
        "kind" = "ClusterIssuer"
      }
      "usages" : ["server auth", "client auth"]
    }
  }
}
