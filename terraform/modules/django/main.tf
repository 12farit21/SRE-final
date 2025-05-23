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

variable "postgres_container_name" {
  type = string
}

# Используем существующий образ вместо сборки
resource "docker_image" "django" {
  name = "django-to-do-web:latest"
  keep_locally = true
}

resource "docker_container" "django" {
  count = 2 # Два контейнера для отказоустойчивости
  image = docker_image.django.name
  name  = "django-app-${count.index}"
  ports {
    internal = 8000
    external = var.django_ports[count.index]
  }
  env = [
    "DATABASE_URL=postgresql://user:password@db:5432/todo_db",
    "DJANGO_SETTINGS_MODULE=core.settings",
    "PYTHONUNBUFFERED=1",
    "TIMEOUT=120"
  ]
  networks_advanced {
    name = var.network_name
  }
  depends_on = []
  restart = "unless-stopped"
  command = [
    "gunicorn",
    "--bind", "0.0.0.0:8000",
    "--timeout", "60",
    "--workers", "1",
    "core.wsgi:application"
  ]
}