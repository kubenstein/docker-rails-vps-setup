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


echo "*********** provide password for git user ***********"
read GIT_USER_PASSWORD


function main() {
  add_non_root_user_on_host
  add_docker_user_on_host
  install_docker
  setup_basic_containers
}


function add_non_root_user_on_host() {
  echo "*********** add user ovh ***********"
  sudo adduser ovh sudo
}


function add_docker_user_on_host() {
  echo "*********** add user docker-host ***********"
  sudo adduser docker-host
}


function install_docker() {
  echo "*********** install docker ***********"
  sudo apt-get install -qq -y wget
  sudo sh -c "wget -qO- https://get.docker.com/ | sh"

  sudo gpasswd -a docker-host docker
  sudo service docker restart
}


function setup_basic_containers() {
  echo "*********** setuping bootstrap container ***********"
  sudo su docker-host <<EOF

  cd setup-contaiers-configuration/
  docker build -t setup-contaiers-configuration .

  echo "* start CONFIGURATOR container"
  docker run -t --rm \
             --name configurator \
             -v /var/run/docker.sock:/var/run/docker.sock \
             -e "GIT_USER_PASSWORD=$GIT_USER_PASSWORD" \
             setup-contaiers-configuration

  echo "* remove CONFIGURATOR tmp images"
  docker rmi setup-contaiers-configuration

EOF
}


# run!
main