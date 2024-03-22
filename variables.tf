variable "stack" {
  type        = string
  description = "Stack name"
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
  default     = 2
  description = "Number of replicas to create"
}

variable "vault_init_image" {
  type        = string
  description = "Image to be used in init job"
}

variable "certificate_issuer" {
  type        = string
  description = "Cert manager issuer name for Ingress certificate"
}


variable "cluster_endpoint" {
  sensitive   = true
  type        = string
  description = "Endpoint of the cluster."
}

variable "cluster_ca" {
  sensitive   = true
  type        = string
  description = "CA certificate of the cluster."
}

variable "k8s_exec_args" {
  type        = list(string)
  description = "Args for Kubernetes provider exec plugin. Example command ['eks', 'get-token', '--cluster-name', '{clusterName}}']"
}

variable "k8s_exec_command" {
  type        = string
  description = "Command name for Kubernetes provider exec plugin. Example - 'aws"
}