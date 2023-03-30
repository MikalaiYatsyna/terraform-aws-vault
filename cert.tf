resource "tls_private_key" "pkey" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "tls_cert_request" "cert_request" {
  private_key_pem = tls_private_key.pkey.private_key_pem
  subject {
    common_name  = "system:node:${local.app_name}.svc"
    organization = "Logistics Online test company"
  }
  dns_names = [
    local.app_name,
    "${local.app_name}.svc",
    "${local.app_name}.svc.cluster",
    "${local.app_name}.svc.cluster.local",
  ]
  ip_addresses = [
    "127.0.0.1"
  ]
}

resource "kubernetes_certificate_signing_request_v1" "vault_server_cert_req" {
  metadata {
    name = "vault-cert-request"
  }
  spec {
    usages      = ["digital signature", "key encipherment", "server auth"]
    signer_name = "beta.eks.amazonaws.com/app-serving"
    request     = tls_cert_request.cert_request.cert_request_pem
  }

  auto_approve = true
}

resource "kubernetes_secret" "vault_server_cert" {
  metadata {
    name      = "${local.app_name}-server-cert"
    namespace = var.namespace
  }
  data = {
    "ca.crt"  = base64decode(data.aws_eks_cluster.eks_cluster.certificate_authority[0].data)
    "tls.crt" = kubernetes_certificate_signing_request_v1.vault_server_cert_req.certificate
    "tls.key" = tls_private_key.pkey.private_key_pem
  }
  type = "kubernetes.io/tls"
}
