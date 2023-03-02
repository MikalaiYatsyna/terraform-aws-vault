variable "stack" {
  type        = string
  description = "Stack name"
}

variable "cluster_name" {
  type        = string
  description = "Name of EKS cluster"
}

variable "namespace" {
  type        = string
  description = "Namespace for Vault release"
}

variable "domain" {
  type        = string
  description = "Root application domain name"
}

variable "oidc_provider_arn" {
  type        = string
  description = "OIDC provider arn"
}

variable "server_replicas" {
  type        = number
  default     = 1
  description = "Number of replicas to create"
}

variable "vault_init_image" {
  type        = string
  description = "Image to be used in init job"
}

variable "certificate_issuer" {
  type = string
  description = "Cert manager issuer name for Ingress certificate"
}
