output "all_container_names" {
  value = concat(
    module.django.django_container_names,
    [module.postgres.postgres_container_name],
    module.monitoring.monitoring_container_names
  )
}