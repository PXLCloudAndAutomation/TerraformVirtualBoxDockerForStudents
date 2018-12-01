provider "docker" {
  version = "~> 1.1"
  host = "tcp://${var.docker_host_ip}:${var.docker_host_port}/"
}


provider "null" {
  version = "~> 1.0"
}


resource "docker_image" "docker_registry" {
  name = "registry:2"
}


resource "docker_container" "registry_container" {
  name = "docker-registry-container"
  image = "${docker_image.docker_registry.latest}"
  
  restart = "always"

  ports {
    internal = 5000
    external = 5000
  }
}


resource "null_resource" "create_image" {
  depends_on = ["docker_container.registry_container"]
  connection {
    type = "ssh"
    host = "${var.ssh_host}"
    port = "${var.ssh_port}"
    user = "${var.ssh_user}"
    private_key = "${file(var.ssh_key)}"
  }

  provisioner "remote-exec" {
    inline = [
      "mkdir -p /home/${var.ssh_user}/image",
    ]
  }
  
  provisioner "file" {
    source      = "./files/Dockerfile"
    destination = "/home/${var.ssh_user}/image/Dockerfile"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo docker build -t example:latest /home/${var.ssh_user}/image/",
      "sudo docker tag example:latest localhost:5000/the-example-image",
      "sudo docker push localhost:5000/the-example-image"
    ]
  }

  provisioner "remote-exec" {
    when    = "destroy"
    inline = [
      "sudo rm -rf /home/${var.ssh_user}/image",
    ]
  }
}
