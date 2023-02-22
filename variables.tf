variable "app_name" {
  description = "Vault app name"
}

variable "stack" {
  type        = string
  description = "Stack name"
}

variable "tooling_namespace" {
  type        = string
  description = "Namespace for Consul release"
}

variable "domain" {
  type        = string
  description = "Root application domain name"
}

variable "create_ingress" {
  type        = bool
  description = "Flag to create ingress"
  default     = true
}

variable "consul_app_name" {
  type        = string
  description = "Consul app name used to lookup ui service"
}

variable "oidc_provider_arn" {
  type        = string
  description = "OIDC provider arn"
}
