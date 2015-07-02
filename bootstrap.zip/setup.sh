#!/bin/bash
#
# This script run on bare virtual machine to configure it.
# script will: - add proper users
#              - install docker
#              - setup basic containers (via special container)
#

# swtich to script location
SCRIPT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd $SCRIPT_DIR


echo "*********** provide password for git user ***********"
read GIT_USER_PASSWORD


function main() {
  add_non_root_user_on_host
  add_docker_user_on_host
  install_docker_if_needed
  setup_basic_containers
}


function add_non_root_user_on_host() {
  echo "*********** add non-root user? ***********"
  echo "y/n"
  read ADD_NON_ROOT_USER
  if [ "$ADD_NON_ROOT_USER" == "y" ]; then
    echo "username:"
    read NON_ROOT_USER
    sudo adduser --gecos "" $NON_ROOT_USER
    sudo adduser $NON_ROOT_USER sudo
  fi
}


function add_docker_user_on_host() {
  echo "*********** add user docker-host ***********"
  sudo adduser --gecos "" docker-host
}


function install_docker_if_needed() {
  echo "*********** install docker ***********"
  DOCKER_INSTALLED=$(sudo initctl list | grep 'docker start/running' | wc -l)
  if [ $DOCKER_INSTALLED -eq 0 ]; then
    sudo apt-get install -qq -y wget
    sudo sh -c "wget -qO- https://get.docker.com/ | sh"
  fi
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