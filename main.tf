locals {
  template_suffix          = split("/", var.template)[1]
  scrubbed_template_suffix = replace(local.template_suffix, "-template", "")
  repo_name                = var.repo_name != null ? var.repo_name : "${var.name}-${local.scrubbed_template_suffix}"
}

module "cloudfront" {
  source  = "scaffoldly/public-website-distribution/aws"
  version = "0.15.1"

  for_each = var.stage_domains

  account_name     = var.account_name
  name             = var.name
  stage            = each.key
  dns_provider     = lookup(each.value, "dns_provider", "unknown-dns-provider")
  dns_domain_id    = lookup(each.value, "dns_domain_id", "unknown-dns-domain-id")
  domain           = lookup(each.value, "domain", "unknown-domain")
  subdomain_suffix = lookup(each.value, "subdomain_suffix", "unknown-subdomain-suffix")
  certificate_arn  = lookup(each.value, "certificate_arn", "unknown-certificate-arn")
  stage_env_vars   = lookup(each.value, "stage_env_vars", {})

  providers = {
    aws.dns = aws.dns
  }
}

module "repository" {
  source  = "scaffoldly/repository/github"
  version = "0.15.1"

  template = var.template
  name     = local.repo_name
}

module "aws_iam" {
  source  = "scaffoldly/public-website-stage-secrets/aws"
  version = "0.15.1"

  for_each = module.cloudfront

  stage           = each.value.stage
  repository_name = module.repository.name
  bucket_name     = each.value.bucket_name
  distribution_id = each.value.distribution_id

  depends_on = [
    module.repository
  ]
}
