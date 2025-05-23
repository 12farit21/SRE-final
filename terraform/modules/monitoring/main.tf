terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

variable "network_name" {
  type = string
}

locals {
  config_path = "C:/Users/acer/Desktop/SRE/django-to-do/terraform"
}

resource "docker_image" "prometheus" {
  name         = "prom/prometheus:v2.48.0"
  keep_locally = true
}

resource "docker_image" "grafana" {
  name         = "grafana/grafana:10.2.0"
  keep_locally = true
}

resource "docker_image" "alertmanager" {
  name         = "prom/alertmanager:v0.26.0"
  keep_locally = true
}

resource "docker_container" "prometheus" {
  image = docker_image.prometheus.name
  name  = "prometheus"
  ports {
    internal = 9090
    external = 9090
  }
  volumes {
    host_path      = "${local.config_path}/prometheus.yml"
    container_path = "/etc/prometheus/prometheus.yml"
  }
  volumes {
    host_path      = "${local.config_path}/rules.yml"
    container_path = "/etc/prometheus/rules.yml"
  }
  volumes {
    volume_name    = docker_volume.prometheus_data.name
    container_path = "/prometheus"
  }
  networks_advanced {
    name = var.network_name
  }
  command = [
    "--config.file=/etc/prometheus/prometheus.yml",
    "--storage.tsdb.path=/prometheus"
  ]
}

resource "docker_container" "grafana" {
  image = docker_image.grafana.name
  name  = "grafana"
  ports {
    internal = 3000
    external = 3000
  }
  env = [
    "GF_SECURITY_ADMIN_USER=admin",
    "GF_SECURITY_ADMIN_PASSWORD=admin"
  ]
  volumes {
    volume_name    = docker_volume.grafana_data.name
    container_path = "/var/lib/grafana"
  }
  networks_advanced {
    name = var.network_name
  }
}

resource "docker_container" "alertmanager" {
  image = docker_image.alertmanager.name
  name  = "alertmanager"
  ports {
    internal = 9093
    external = 9093
  }
  volumes {
    host_path      = "${local.config_path}/alertmanager.yml"
    container_path = "/etc/alertmanager/alertmanager.yml"
  }
  volumes {
    volume_name    = docker_volume.alertmanager_data.name
    container_path = "/alertmanager"
  }
  networks_advanced {
    name = var.network_name
  }
  command = ["--config.file=/etc/alertmanager/alertmanager.yml"]
}

resource "docker_volume" "prometheus_data" {
  name = "prometheus_data"
}

resource "docker_volume" "grafana_data" {
  name = "grafana_data"
}

resource "docker_volume" "alertmanager_data" {
  name = "alertmanager_data"
}