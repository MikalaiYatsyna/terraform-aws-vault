provider "kubernetes" {
  host                   = var.cluster_endpoint
  cluster_ca_certificate = base64decode(var.cluster_ca)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args        = var.k8s_exec_args
    command     = var.k8s_exec_command
  }
}

provider "helm" {
  kubernetes {
    host                   = var.cluster_endpoint
    cluster_ca_certificate = base64decode(var.cluster_ca)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = var.k8s_exec_args
      command     = var.k8s_exec_command
    }
  }
}

provider "aws" {}
