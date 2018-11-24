provider "docker" {
  host = "tcp://${var.docker_host_ip}:${var.docker_host_port}/"
}

resource "docker_image" "nginx" {
  name = "nginx:1.15"
}

resource "docker_network" "inner" {
  name   = "inner-docker-network"
  driver = "bridge"
}

# ----------------------------------------------------------------------------
# Exercise step 1: Log in to the box (i.e. $ vagrant ssh)
# Observe part 1 : Check the containers (i.e. $ sudo docker ps -a)
# Exercise step 2: Connect to webserver2 (i.e. $ sudo docker exe -i -t webserver2 /bin/bash)
# Exercise step 3: Install ping (i.e. $ apt install iputils-ping)
# Observe part 2 : Notice it doesn't work out of the box.
# Question       : Why?
# Answer         : ___________________________________________________________
# Conclusion     : Containers are made as small as possible.
# Exercise step 4: Update the package list (i.e. $ apt update) and do step 3 again.
# Exercise step 5: Ping the other containers via DNS name. (i.e. $ ping webserver1)
# Observe part 3 : They respond!
# Conclusion     : Docker user defined networks provide IPs, DNS & all ports are open.
# ----------------------------------------------------------------------------
resource "docker_container" "webserver" {
  count = 4
  name = "webserver${count.index + 1}"
  image = "${docker_image.nginx.latest}"

  networks_advanced = [    
    {
      name = "${docker_network.inner.name}"
    }
  ]
}
