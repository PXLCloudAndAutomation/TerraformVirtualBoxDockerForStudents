# Configure the Docker provider
# +/- From https://www.terraform.io/docs/providers/docker/
#
  
# ------------------------------------------------------------------------------
# Exercise step 1: Apply this setup.
# Observe part 1 : Inspect the Terraform output.
# Observe part 2 : Inspect the container on the docker host. (i.e. $ sudo docker ps -a)
# Observe part 3 : Inspect the image on the docker host. (i.e. $ sudo docker image ls)
# Exercise step 1: Destroy this setup. (i.e. $ terraform destroy)
# Observe part 1 : Inspect the Terraform output.
# Observe part 2 : Inspect the container on the docker host. (i.e. $ sudo docker ps -a)
# Observe part 3 : Inspect the image on the docker host. (i.e. $ sudo docker image ls)
# Question       : Is there anything left on the docker host?
# Answer         : _____________________________________________________________
# Conclusion     : Destroy removes everything.
# ------------------------------------------------------------------------------
provider "docker" {
  version = "~> 1.1"
  host = "tcp://${var.docker_host_ip}:${var.docker_host_port}/"
}

# Create a container
resource "docker_container" "foo" {
  image = "${docker_image.ubuntu.latest}"
  name  = "foo"
}

resource "docker_image" "ubuntu" {
  name = "ubuntu:latest"
}

