provider "docker" {
  version = "~> 1.1"
  host = "tcp://${var.docker_host_ip}:${var.docker_host_port}/"
}


resource "docker_image" "openproject" {
  name = "openproject/community:8"
}


resource "docker_container" "openproject-server" {
  depends_on = ["null_resource.provision_requirements"]
  name = "openproject-server"
  image = "${docker_image.openproject.latest}"
  
  # Passing docker -e values.
  env = ["SECRET_KEY_BASE=secret", ]
  
  ports {
    internal = 80
    external = 80
  }

  # ----------------------------------------------------------------------------
  # Exercise step 1: Destroy this setup. (i.e. $ terraform destroy)
  # Exercise step 2: Make all volumes below read only and reapply.
  # Observe part 1 : Inspect the Terraform output.
  # Observe part 2 : No errors?
  # Observe part 3 : Check if the site is up and running.
  # Observe part 4 : Check if the container is up and running & the dirs.
  # Question       : Why didn't Terraform complain?
  # Answer         : ___________________________________________________________
  # Conclusion     : The output is not conclusive!
  # Exercise step 3: Make all volumes below readable again and reapply.
  # Observe part 5 : Check if the container is up and running & the dirs.
  # Observe part 6 : Check if the site is up and running. (Be very patient.)
  # Conclusion     : The output is not conclusive, always test the services.
  # ----------------------------------------------------------------------------
  volumes {
    container_path  = "/var/lib/postgresql/9.6/main"
    host_path = "/home/${var.ssh_user}/openproject/pgdata"
    read_only = false
  }

  volumes {
    container_path  = "/var/log/supervisor"
    host_path = "/home/${var.ssh_user}/openproject/logs"
    read_only = false
  }

  volumes {
    container_path  = "/var/db/openproject"
    host_path = "/home/${var.ssh_user}/openproject/static"
    read_only = false
  }
}


resource "null_resource" "provision_requirements" {
  depends_on = ["docker_image.openproject"]
  connection {
    type = "ssh"
    host = "${var.ssh_host}"
    port = "${var.ssh_port}"
    user = "${var.ssh_user}"
    private_key = "${file(var.ssh_key)}"
  }

  provisioner "remote-exec" {
    inline = [
      "mkdir -p /home/${var.ssh_user}/openproject/{pgdata,logs,static}",
    ]
  }
  
  # ----------------------------------------------------------------------------
  # Exercise step 1: Destroy this setup. (i.e. $ terraform destroy)
  # Exercise step 2: Remove the sudo, reapply, play with the site and destroy it.
  # Observe part 1 : Inspect the $ terraform destroy output for errors.
  # Question       : Why did Terraform complain?
  # Answer         : ___________________________________________________________
  # Conclusion     : Be awere (and beware) for permisions set by a container.
  # Exercise step 3: Add the sudo back again and redestroy this project.
  # ----------------------------------------------------------------------------
  # Note: This is a test environment, in production you DO NOT delete this dir.
  provisioner "remote-exec" {
    when    = "destroy"
    inline = [
      "sudo rm -rf /home/${var.ssh_user}/openproject",
    ]
  }
}
