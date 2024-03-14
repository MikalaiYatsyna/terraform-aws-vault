terraform {
  required_version = "1.7.5"
  required_providers {
    aws = {
      version = "5.40.0"
      source  = "hashicorp/aws"
    }
    kubernetes = {
      version = "2.27.0"
      source  = "hashicorp/kubernetes"
    }
    helm = {
      version = "2.12.1"
      source  = "hashicorp/helm"
    }
    tls = {
      version = "4.0.5"
      source  = "hashicorp/tls"
    }
    time = {
      version = "0.11.1"
      source  = "hashicorp/time"
    }
  }
}
