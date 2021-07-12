[![Maintained by Scaffoldly](https://img.shields.io/badge/maintained%20by-scaffoldly-blueviolet)](https://github.com/scaffoldly)
![GitHub release (latest SemVer)](https://img.shields.io/github/v/release/scaffoldly/terraform-aws-public-website)
![Terraform Version](https://img.shields.io/badge/tf-%3E%3D0.15.0-blue.svg)

## Description

Configure a Public Website based configuration in stage domains.

Basically a wrapper/loop for the following modules:

scaffoldly/public-website-distribution/aws (1 per stage)
scaffoldly/repository/github (1 per module)
scaffoldly/public-website-stage-secrets/aws (1 per module)

## Usage

```hcl
module "public_website" {
  source = "scaffoldly/public-website/aws"

  for_each = var.public_websites

  account_name  = module.aws_organization.account_name
  name          = each.key
  stage_domains = module.dns.stage_domains

  template  = lookup(each.value, "template", "scaffoldly/web-cdn-template")
  repo_name = lookup(each.value, "repo_name", null)

  providers = {
    aws.dns = aws.root
  }

  depends_on = [
    module.dns,
    module.aws_logging
  ]
}

```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.15 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 3.33.0 |
| <a name="requirement_github"></a> [github](#requirement\_github) | 4.9.4 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_aws_iam"></a> [aws\_iam](#module\_aws\_iam) | scaffoldly/public-website-stage-secrets/aws | 0.15.1 |
| <a name="module_cloudfront"></a> [cloudfront](#module\_cloudfront) | scaffoldly/public-website-distribution/aws | 0.15.1 |
| <a name="module_repository"></a> [repository](#module\_repository) | scaffoldly/repository/github | 0.15.1 |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_name"></a> [account\_name](#input\_account\_name) | The AWS account name | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | The service name | `string` | n/a | yes |
| <a name="input_repo_name"></a> [repo\_name](#input\_repo\_name) | The desired repository name | `string` | `""` | no |
| <a name="input_stage_domains"></a> [stage\_domains](#input\_stage\_domains) | The stage domain config (the output from the terraform-aws-dns module) | <pre>map(<br>    object({<br>      domain                = string<br>      subdomain             = string<br>      subdomain_suffix      = string<br>      serverless_api_domain = string<br>      platform_domains      = map(string)<br>      certificate_arn       = string<br>      dns_provider          = string<br>      dns_domain_id         = string<br>      stage_env_vars        = map(string)<br>    })<br>  )</pre> | n/a | yes |
| <a name="input_template"></a> [template](#input\_template) | Organization and template repo name (e.g. scaffoldly/sls-rest-api-template) | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_repository_name"></a> [repository\_name](#output\_repository\_name) | n/a |
| <a name="output_service_name"></a> [service\_name](#output\_service\_name) | n/a |
| <a name="output_stage_env_vars"></a> [stage\_env\_vars](#output\_stage\_env\_vars) | n/a |
<!-- END_TF_DOCS -->
