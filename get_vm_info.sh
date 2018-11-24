#!/bin/bash

NIC="eth1"  # TODO: Change to the correct NIC!

echo -n "docker_host_ip = \""
vagrant ssh -c "ip addr show $NIC | grep inet\  | cut -d/ -f1 | tr -d inet | tr -d ' \n'" 2> /dev/null
echo "\""

echo -n "ssh_host = \""
vagrant ssh-config | grep HostName\ | xargs | cut -d " " -f2 | tr -d " \n"
echo "\""

echo -n "ssh_port = \""
vagrant ssh-config | grep Port\ | xargs | cut -d " " -f2 | tr -d " \n"
echo "\""

echo -n "ssh_user = \""
vagrant ssh-config | grep User\ | xargs | cut -d " " -f2 | tr -d " \n"
echo "\""

echo -n "ssh_key = \""
vagrant ssh-config | grep IdentityFile\ | xargs | cut -d " " -f2 | tr -d " \n"
echo "\""
