#!/bin/bash
#
# This script run on bare virtual machine to configure it.
# script will: - add proper users
#              - install docker
#              - setup basic containers (via special container)
#
set -e

# swtich to script location
SCRIPT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd $SCRIPT_DIR


# add users 
echo "* add user ovh"
adduser ovh sudo
passwd ovh
su ovh

echo "* add user docker-host"
sudo adduser docker-host
sudo passwd docker-host

echo "* git user password"
read GIT_USER_PASSWORD


# install docker 
echo "* install docker"
sudo apt-get install -qq -y wget
sudo sh -c "wget -qO- https://get.docker.com/ | sh"

sudo gpasswd -a docker-host docker
sudo service docker restart


# setuping site componets
echo "* setuping bootstrap container"
cd setup-contaiers-configuration/
docker build -t setup-contaiers-configuration .
docker run -it --rm \
           --name configurator \
           -v /var/run/docker.sock:/var/run/docker.sock \
           -e "GIT_USER_PASSWORD=$GIT_USER_PASSWORD" \
           setup-contaiers-configuration


# # from local 
# cat .ssh/id_rsa.pub | ssh git@10.0.0.115 "cat >> ~/.ssh/authorized_keys"