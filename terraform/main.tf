terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "docker" {
  host = "npipe:////./pipe/docker_engine"
}

resource "docker_network" "app_network" {
  name = "todo-app-network"
}

module "django" {
  source = "./modules/django"
  network_name = docker_network.app_network.name
  postgres_container_name = module.postgres.postgres_container_name
}

module "postgres" {
  source = "./modules/postgres"
  network_name = docker_network.app_network.name
}

module "monitoring" {
  source = "./modules/monitoring"
  network_name = docker_network.app_network.name
}