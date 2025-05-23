output "django_container_names" {
  value = docker_container.django[*].name
}