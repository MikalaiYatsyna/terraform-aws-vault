variable "region" {}

variable "app_name" {
  description = "Consul app name"
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
  description = "Consul app name used to lookup ui service"
}

variable "tfe_organization" {
  description = "Name of Terraform Cloud organization"

}

variable "tfe_eks_workspace_name" {
  description = "Name of Terraform Cloud eks workspace"
}