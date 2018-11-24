provider "docker" {
  host = "tcp://${var.docker_host_ip}:${var.docker_host_port}/"
}


resource "docker_image" "nginx" {
  name = "nginx:1.11-alpine"
  #name = "nginx:1.15.5-alpine"
  
  # ----------------------------------------------------------------------------
  # Exercise step 1: Comment version 1.11 & uncomment version 1.15 and reapply.
  # Observe part 1 : This doesn't effect the container. (Refresh an error page.)
  # Exercise step 2: Uncomment version 1.11 & comment 1.15 and reapply.
  # Observe part 2 : This destroys and recreate the container! (Check the version.)
  # Observe (Tip?) : The image changes but the container will only run 1.11...
  # Question       : Why doesn't the container run the new nginx?
  # Answer         : ___________________________________________________________
  # Conclusion     : This is clearly not the way to change software versions.
  # Exercise step 3: Find a solution to correctly change between nginx versions.
  # Answer         : ___________________________________________________________
  # ----------------------------------------------------------------------------
}


resource "docker_container" "nginx-server" {
  depends_on = ["null_resource.provision_site"]

  name = "nginx-server"
  image = "${docker_image.nginx.latest}"

  ports {
    internal = 80
    external = 80
  }

  volumes {
    container_path  = "/usr/share/nginx/html"
    host_path = "/home/${var.ssh_user}/www"
    read_only = true
  }
}


resource "null_resource" "provision_site" {

  connection {
    type = "ssh"
    host = "${var.ssh_host}"
    port = "${var.ssh_port}"
    user = "${var.ssh_user}"
    private_key = "${file(var.ssh_key)}"
  }

  # ----------------------------------------------------------------------------
  # Exercise step 1: Completely destroy this setup. (i.e. $ terraform destroy) 
  # Exercise step 2: Comment all the provisioner blocks below and reapply.
  # Observe part 0 : Yes, there is no HTML page to serve. (Doesn't matter here.)
  # Observe part 1 : Check if the www directory exists. (i.e. $ vagrant ssh & ll)
  # Observe part 2 : Check the owner of the www directory.
  # Question (Tip) : Could this change of ownership cause any problems? (Tip: Y..)
  # Answer         : ___________________________________________________________
  # Conclusion     : This is clearly not good.
  # Question       : What process created the www directory?
  # Answer         : ___________________________________________________________
  # Conclusion     : Always create the prerequisites with the correct user.
  # Exercise step 3: Uncomment all the provisioner blocks below and reapply.
  # Observe part 3 : Terraform response: No changes. Infrastructure is up-to-date.
  # Question (Tip) : How can changes be foreced to apply? (It's a tainted answer.)
  # Answer         : ___________________________________________________________
  # Question (Tip) : Will one "taint" be enough? (Tip: N.), why?
  # Answer         : ___________________________________________________________
  # ----------------------------------------------------------------------------
  provisioner "remote-exec" {
    inline = [
      "mkdir -p /home/${var.ssh_user}/www",
    ]
  }
  
  provisioner "file" {
    source      = "./files/index.html"
    destination = "/home/${var.ssh_user}/www/index.html"
  }

  provisioner "remote-exec" {
    when    = "destroy"
    inline = [
      "rm -rf /home/${var.ssh_user}/www",
    ]
  }
}
