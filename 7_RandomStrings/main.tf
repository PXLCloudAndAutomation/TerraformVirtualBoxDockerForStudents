provider "docker" {
  host = "tcp://${var.docker_host_ip}:${var.docker_host_port}/"
}

resource "random_string" "name" {
  length = 7
  special = false
}

# Create a container
resource "docker_container" "foo" {
  image = "${docker_image.ubuntu.latest}"
  name  = "${random_string.name.result}"
}

resource "docker_image" "ubuntu" {
  name = "ubuntu:latest"
}

