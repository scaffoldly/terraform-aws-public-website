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

## Providers

## Modules

## Resources

## Inputs

## Outputs

<!-- END_TF_DOCS -->
