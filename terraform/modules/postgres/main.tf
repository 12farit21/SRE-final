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

resource "docker_image" "postgres" {
  name         = "postgres:15"
  keep_locally = true
}

resource "docker_image" "postgres_exporter" {
  name         = "prometheuscommunity/postgres-exporter:v0.15.0"
  keep_locally = true
}

resource "docker_container" "postgres" {
  image = docker_image.postgres.name
  name  = "db"
  env = [
    "POSTGRES_USER=user",
    "POSTGRES_PASSWORD=password",
    "POSTGRES_DB=todo_db"
  ]
  volumes {
    volume_name = docker_volume.postgres_data.name
    container_path = "/var/lib/postgresql/data"
  }
  networks_advanced {
    name = var.network_name
  }
  restart = "unless-stopped"
}

resource "docker_container" "postgres_exporter" {
  image = docker_image.postgres_exporter.name
  name  = "postgres_exporter"
  env = [
    "DATA_SOURCE_NAME=postgresql://user:password@db:5432/todo_db?sslmode=disable"
  ]
  ports {
    internal = 9187
    external = 9187
  }
  networks_advanced {
    name = var.network_name
  }
  depends_on = [docker_container.postgres]
}

resource "docker_volume" "postgres_data" {
  name = "postgres_data"
}