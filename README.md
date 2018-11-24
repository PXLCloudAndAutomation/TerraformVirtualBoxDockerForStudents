# Terraform VirtualBox Docker Examples
A collection of Terraform examples and exercises using VirtualBox via Vagrant and Docker to demonstrate different concepts.

Commit all the answers to your personal Cloud & Automation repository, acquired during the first lesson.

## Prerequisites
There are a few prerequisites to use these examples:

* A Unix-like host OS (OSX, GNU/Linux)
* VirtualBox (Version 5.2.20)
* Vagrant (Version 2.2.0)
* Terraform (Version v0.11.8)
* Internet access

## Before running ANY example
### 1. Create the virtual machine
A `VagrantFile` is provided to automatically create the VirtualBox machine. It's located in the root directory of this repository. Create the virtual machine by executing the following command in the repo's root dir.

```bash
$ vargrant up
```

It will bring up a CentOS 7 machine and installs Docker. This will also create the `.vagrant` hidden directory where the VM will live. 

### 2. Extract the necessary values and store them
The root directory contains the `terraform.tfvars` file. Each example needs the same information and it will be stored inside this file. A convenient bash script extracts the values form Vagrant. Redirect the output of this script to the file before running any example.

```bash
$ ./get_vm_info.sh > terraform.tfvars
```

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
$ terraform destroy
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
It's also possible to output certain values to the command line after all the changes are applied. This example demonstrate this.

