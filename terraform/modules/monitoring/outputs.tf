output "monitoring_container_names" {
  value = [
    docker_container.prometheus.name,
    docker_container.grafana.name,
    docker_container.alertmanager.name
  ]
}