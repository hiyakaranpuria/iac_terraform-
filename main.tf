terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "docker" {}

# --------------------------
# Variables
# --------------------------
variable "image_name" {
  description = "Docker Hub image to pull"
  type        = string
  default     = "hiya855/url-shortener:latest"
}

variable "container_name" {
  description = "Name of the Docker container"
  type        = string
  default     = "url-shortener-tf"
}

variable "internal_port" {
  description = "Port the app listens on inside the container"
  type        = number
  default     = 3000
}

variable "external_port" {
  description = "Port exposed on the host machine"
  type        = number
  default     = 3000
}

# --------------------------
# Resources
# --------------------------

# Pull image from Docker Hub
resource "docker_image" "url_shortener" {
  name         = var.image_name
  keep_locally = false
}

# Create and run the container
resource "docker_container" "url_shortener" {
  name  = var.container_name
  image = docker_image.url_shortener.image_id

  ports {
    internal = var.internal_port
    external = var.external_port
  }

  restart = "always"
}

# --------------------------
# Outputs
# --------------------------
output "container_name" {
  description = "Name of the running container"
  value       = docker_container.url_shortener.name
}

output "container_id" {
  description = "ID of the running container"
  value       = docker_container.url_shortener.id
}

output "app_url" {
  description = "URL to access the application"
  value       = "http://localhost:${var.external_port}"
}
