output "service_name" {
  value = var.name
}

output "repository_name" {
  value = module.repository.name
}

output "stage_env_vars" {
  value = {
    for stage in module.cloudfront :
    stage.stage => stage.stage_env_vars
  }
}
