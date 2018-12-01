provider "docker" {
  version = "~> 1.1"
  host = "tcp://${var.docker_host_ip}:${var.docker_host_port}/"
}


resource "docker_image" "portainer" {
  name = "portainer/portainer"
}

resource "docker_volume" "shared_volume" {
    name = "shared_volume"
}

resource "docker_container" "portainer" {
  name = "portainer"
  image = "${docker_image.portainer.latest}"

  restart = "always"

  ports {
    internal = 9000
    external = 9000
  }

  volumes {
    volume_name     = "${docker_volume.shared_volume.name}"
    container_path  = "/data portainer/portainer"
  }

  volumes {
    container_path  = "/var/run/docker.sock"
    host_path = "/var/run/docker.sock"
  }
}
