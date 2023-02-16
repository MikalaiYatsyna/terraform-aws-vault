## Introduction
Terraform module to create Vault cluster on AWS EKS

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.54.0 |
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_records"></a> [records](#module\_records) | terraform-aws-modules/route53/aws//modules/records | n/a |
| <a name="module_vault"></a> [vault](#module\_vault) | app.terraform.io/logistic/vault/helm | n/a |
| <a name="module_vault_role"></a> [vault\_role](#module\_vault\_role) | terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.vault_kms_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_kms_key.vault_unseal_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_eks_cluster.eks_cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster) | data source |
| [aws_eks_cluster_auth.eks_cluster_auth](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster_auth) | data source |
| [aws_lb.ingress_lb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/lb) | data source |
| [aws_route53_zone.zone](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |
| [terraform_remote_state.eks](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_app_name"></a> [app\_name](#input\_app\_name) | Consul app name | `any` | n/a | yes |
| <a name="input_consul_app_name"></a> [consul\_app\_name](#input\_consul\_app\_name) | Consul app name used to lookup ui service | `any` | n/a | yes |
| <a name="input_create_ingress"></a> [create\_ingress](#input\_create\_ingress) | Flag to create ingress | `bool` | `true` | no |
| <a name="input_domain"></a> [domain](#input\_domain) | Root application domain name | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | n/a | `any` | n/a | yes |
| <a name="input_stack"></a> [stack](#input\_stack) | Stack name | `string` | n/a | yes |
| <a name="input_tfe_eks_workspace_name"></a> [tfe\_eks\_workspace\_name](#input\_tfe\_eks\_workspace\_name) | Name of Terraform Cloud eks workspace | `any` | n/a | yes |
| <a name="input_tfe_organization"></a> [tfe\_organization](#input\_tfe\_organization) | Name of Terraform Cloud organization | `any` | n/a | yes |
| <a name="input_tooling_namespace"></a> [tooling\_namespace](#input\_tooling\_namespace) | Namespace for Consul release | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
