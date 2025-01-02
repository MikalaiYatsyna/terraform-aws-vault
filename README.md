## Introduction
Terraform module to create Vault cluster on AWS EKS

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | 1.10.3 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 5.42.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | 2.12.1 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | 2.35.1 |
| <a name="requirement_time"></a> [time](#requirement\_time) | 0.12.1 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | 4.0.6 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.42.0 |
| <a name="provider_helm"></a> [helm](#provider\_helm) | 2.12.1 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.35.1 |
| <a name="provider_time"></a> [time](#provider\_time) | 0.12.1 |
| <a name="provider_tls"></a> [tls](#provider\_tls) | 4.0.6 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_vault_role"></a> [vault\_role](#module\_vault\_role) | terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_dynamodb_table.vault-backend](https://registry.terraform.io/providers/hashicorp/aws/5.42.0/docs/resources/dynamodb_table) | resource |
| [aws_iam_policy.vault_kms_policy](https://registry.terraform.io/providers/hashicorp/aws/5.42.0/docs/resources/iam_policy) | resource |
| [aws_kms_key.vault_unseal_key](https://registry.terraform.io/providers/hashicorp/aws/5.42.0/docs/resources/kms_key) | resource |
| [aws_secretsmanager_secret.vault_root_token](https://registry.terraform.io/providers/hashicorp/aws/5.42.0/docs/resources/secretsmanager_secret) | resource |
| [helm_release.vault](https://registry.terraform.io/providers/hashicorp/helm/2.12.1/docs/resources/release) | resource |
| [kubernetes_certificate_signing_request_v1.vault_server_cert_req](https://registry.terraform.io/providers/hashicorp/kubernetes/2.35.1/docs/resources/certificate_signing_request_v1) | resource |
| [kubernetes_job.vault_init_job](https://registry.terraform.io/providers/hashicorp/kubernetes/2.35.1/docs/resources/job) | resource |
| [kubernetes_secret.sa-token](https://registry.terraform.io/providers/hashicorp/kubernetes/2.35.1/docs/resources/secret) | resource |
| [kubernetes_secret.vault_server_cert](https://registry.terraform.io/providers/hashicorp/kubernetes/2.35.1/docs/resources/secret) | resource |
| [kubernetes_service_account.vault-sa](https://registry.terraform.io/providers/hashicorp/kubernetes/2.35.1/docs/resources/service_account) | resource |
| [time_sleep.vault_release](https://registry.terraform.io/providers/hashicorp/time/0.12.1/docs/resources/sleep) | resource |
| [tls_cert_request.cert_request](https://registry.terraform.io/providers/hashicorp/tls/4.0.6/docs/resources/cert_request) | resource |
| [tls_private_key.pkey](https://registry.terraform.io/providers/hashicorp/tls/4.0.6/docs/resources/private_key) | resource |
| [aws_eks_cluster.eks_cluster](https://registry.terraform.io/providers/hashicorp/aws/5.42.0/docs/data-sources/eks_cluster) | data source |
| [aws_eks_cluster_auth.eks_cluster_auth](https://registry.terraform.io/providers/hashicorp/aws/5.42.0/docs/data-sources/eks_cluster_auth) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/5.42.0/docs/data-sources/region) | data source |
| [aws_secretsmanager_secret_version.vault_root_token](https://registry.terraform.io/providers/hashicorp/aws/5.42.0/docs/data-sources/secretsmanager_secret_version) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_certificate_issuer"></a> [certificate\_issuer](#input\_certificate\_issuer) | Cert manager issuer name for Ingress certificate | `string` | n/a | yes |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of EKS cluster | `string` | n/a | yes |
| <a name="input_domain"></a> [domain](#input\_domain) | Root application domain name | `string` | n/a | yes |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace for Vault release | `string` | n/a | yes |
| <a name="input_oidc_provider_arn"></a> [oidc\_provider\_arn](#input\_oidc\_provider\_arn) | OIDC provider arn | `string` | n/a | yes |
| <a name="input_server_replicas"></a> [server\_replicas](#input\_server\_replicas) | Number of replicas to create | `number` | `2` | no |
| <a name="input_stack"></a> [stack](#input\_stack) | Stack name | `string` | n/a | yes |
| <a name="input_vault_init_image"></a> [vault\_init\_image](#input\_vault\_init\_image) | Image to be used in init job | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_vault_address"></a> [vault\_address](#output\_vault\_address) | Vault address |
| <a name="output_vault_sa"></a> [vault\_sa](#output\_vault\_sa) | Vault service account name |
| <a name="output_vault_server_cert_secret_name"></a> [vault\_server\_cert\_secret\_name](#output\_vault\_server\_cert\_secret\_name) | n/a |
| <a name="output_vault_token_secret_id"></a> [vault\_token\_secret\_id](#output\_vault\_token\_secret\_id) | Id of Vault root token secret in AWS Secret Manager |
<!-- END_TF_DOCS -->
