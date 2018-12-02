# Terraform VirtualBox Docker Examples
This is a collection of Terraform examples and exercises using Docker to demonstrate different concepts.
A Linux machine with Docker is needed to use these examples. You can create this machine and configure its software manually or use Vagrant to create the VM in VirtualBox with the necessary software automatically.

These examples also contain a few exercises.
**Commit all the answers to your personal Cloud & Automation repository, acquired during the first lesson.**

## Prerequisites (Do this before running ANY example)
There are a few prerequisites for these examples. There main prerequisite is a virtual machine with `docker-ce`, Terraform and a few other packages. Like stated before, it's possible to create the VM using Vagrant (**A.**) or do it completely manually (**B.**).

### A. Automatically create the VM with Vagrant in 2 steps
The following items are needed to create the VM automatically with Vagrant:

* A Unix-like host OS (OSX, GNU/Linux)
* VirtualBox (Version 5.2.20)
* Vagrant (Version 2.2.0)
* Terraform (Version v0.11.10)
* Internet access

**Note:** it's possible to use Windows, but the `get_vm_info.sh` file, used in step 2, needs to be altered.
The line endings do not match with those of Windows. Or you can just add the correct information to the `terraform.tfvars` file by hand.

#### 1. Create the virtual machine
The `VagrantFile` to automatically create the VirtualBox machine is located in the root directory of this repository. Create the virtual machine by executing the following command in the repo's root dir.

```bash
$ vargrant up
```

This will bring up a CentOS 7 machine and installs Docker and prepares it for the examples. This will create the `.vagrant` hidden directory where the VM and the generated SSH key will live.

**Remark:** It's recommended to view the contents of the `VagrantFile`. By doing so, a decent understanding of the configured software is acquired.

#### 2. Extract the necessary values for Terraform and store them in the `.tfvars` file.
The root directory contains the `terraform.tfvars` file. Each example needs the same information and it will be stored inside this file. A convenient bash script extracts the values form Vagrant. Redirect the output of this script to the file before running any example.

```bash
$ ./get_vm_info.sh > terraform.tfvars
```
**Remark:** It's recommended to view the contents of both files, after running the script. By doing so, a decent understanding is acquired.

### B. Manually create the VM
The following items are needed to create the VM manually

* A 64bit Ubuntu 18.04 Desktop VM with internet access and OpenSSH server (2 CPUs, 4GB RAM, 20GB+ storage)
* Docker-ce
* `dockerd` listening on TCP IP 127.0.0.1 and port 2375
* Passwordless SSH key access to 127.0.0.1
* A sudo user who doesn't need to enter a password.
* Terraform (Version v0.11.10)

#### 1. Creating a virtual machine with Ubuntu 18.04, internet access and OpenSSH server
The creation and installation of Ubuntu was covered in the course Desktop OS during the first year.
Installing an OpenSSH server is part of the Server Essentials course (2nd year).


#### 2. Install Docker-ce incl. dockerd listening on TCP IP 127.0.0.1 and port 2375
De following link explains, during its first step (Step 1), how to install `docker-ce`. The other steps (Step 2 - ...) are not needed for this repository.

[How to install and use docker on Ubuntu 18.04 by Digital Ocean](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-18-04)

#### 3. Passwordless SSH key access to 127.0.0.1
Although these commands are part of the Linux Server Essentials course from the 2nd year, we listed them here.
To generate an SSH key on Ubuntu execute:

```bash
$ ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
```
**IMPORTANT:** Leave the defaults and do not enter a passphrase.

To added passwordless SSH login to the VM itself:

```bash
$ ssh-copy-id -i ~/.ssh/id_rsa.pub $USER@127.0.0.1 
```

Test the SSH passwordless connection:

```bash
$ ssh $USER@127.0.0.1 
```

#### 4. Passwordless sudo
To remove the password asking phase of sudo, at least for the current user (change YOUR_USER_NAME to your username), add the following line to `/etc/sudoers`.

```bash
   YOUR_USER_NAME ALL=(ALL:ALL) NOPASSWD:ALL
```

**Do this with the `visudo`, like you have been taught in the Server Essentials Course!**

Reboot to complete this step.

#### 5. `dockerd` listening on TCP 127.0.0.1 port 2375
Edit the file `/lib/systemd/system/docker.service`:

```bash
$ sudo vi /lib/systemd/system/docker.service
```

Modify the line stating with `ExecStart`, more specific add `-H tcp://127.0.0.1:2375` at the end of the line.
**DO NOT change the existing part.** The line should end up looking like:

```bash
ExecStart=/usr/bin/dockerd -H unix:// -H tcp://0.0.0.0:2375
```

or:

```bash
ExecStart=/usr/bin/dockerd -H fd:// -H tcp://0.0.0.0:2375
```

All that's left for Docker is to restart and enable it on boot. Enter therefor these two commands:

```bash
$ sudo systemctl enable docker.service
$ sudo systemctl start docker.service
```

To test this part, execute an HTTP request with the `curl` command to `localhost` or IP `127.0.0.1`, always specify port `2375` and the page `version`:

```bash
$ curl http://127.0.0.1:2375/version
```

The response should be in `JSON` format and look like:

```bash
{"Platform":{"Name":"Docker Engine - Community"},"Components":[{"Name":"Engine","Version":"18.09.0","Details":{"ApiVersion":"1.39","Arch":"amd64","BuildTime":"2018-11-07T00:19:08.000000000+00:00","Experimental":"false","GitCommit":"4d60db4","GoVersion":"go1.10.4","KernelVersion":"3.10.0-862.14.4.el7.x86_64","MinAPIVersion":"1.12","Os":"linux"}}],"Version":"18.09.0","ApiVersion":"1.39","MinAPIVersion":"1.12","GitCommit":"4d60db4","GoVersion":"go1.10.4","Os":"linux","Arch":"amd64","KernelVersion":"3.10.0-862.14.4.el7.x86_64","BuildTime":"2018-11-07T00:19:08.000000000+00:00"}
```

#### 6. Fillin the correct `terraform.tfvars`
Docker is installed on the local machine and it's possible to SSH to localhost using only the key. In other words, the virtual machine also acts as the remote server. After cloning this repository, edit the  `terraform.tfvars` file and fill-in the correct values:

```bash
docker_host_ip = "127.0.0.1"
ssh_host = "127.0.0.1"
ssh_port = "22"
ssh_user = "vagrant"
ssh_key = "˜/.ssh/id_rsa.pub"
```

**If you followed all these steps correctly, you are ready to plan, apply and destroy all the examples!**

## Run an example
### 1. Go into the desired directory.
For example:

```bash
$ cd 0_FirstSteps/
```

### 2. Initialize the plugins
```bash
$ terraform init
```

### 2. Plan the changes
```bash
$ terraform plan -var-file=../terraform.tfvars
```
### 3. Apply the changes
 ```bash
 $ terraform apply -var-file=../terraform.tfvars
 ```

## Before moving to another example
Always clean up before going to the next (or previous) example, otherwise (strange) errors can occur. Debugging those is time consuming.

```bash
$ terraform destroy -var-file=../terraform.tfvars
```

## The examples and exercise.
This gives a short overview of all the examples.

### `0_FirstSteps`
Take a few first steps with Terraform and its Docker provider.

###  `1_Portainer`
This creates [Portainer](https://portainer.io) container, it will be used as the management UI.

###  `2_nginx`
This creates a simple [nginx](https://www.nginx.com) container and serves a single webpage.

###  `3_OpenProject`
The  `3_OpenProject` example creates a complete (single container) [OpenProject](https://www.openproject.org/), the Collaborative Project Management system. The `main.tf` file also contains two exercises.

###  `4_UserDefinedBridgeNetwork`
Learn how to create an User Defined Network (bridged). This example also contains an exercises.

###  `5_DrupalWithMySQLPHPAndMyAdmin` !!! EXERCISE !!!
This is an exercise. Building upon the gained knowledge of the previous examples, this one will create three containers to provide a Drupal setup. (Not configured!)

Look at the `main.tf` file for more instructions.

###  `6_SimpleDockerRegistry`
An simple (and insecure) Docker Registry example with a DockerFile to create an fresh container image.

###  `7_RandomStrings`
A small example how to generate random strings with Terraform.

###  `8_Output`
It's also possible to output certain values to the command line after all the changes are applied. This example demonstrates this.

