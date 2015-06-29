#!/bin/bash
#
# This script is lauch inside configuration container
# It will create all basic containers on the host mashine
#

function main() {
  build_custom_images
  setup_db_volume_container
  setup_db_container
  setup_git_receiver_storage
  setup_git_receiver
}


function build_custom_images() {
  docker build -t git-receiver ./image-files/git-receiver
}


function setup_db_volume_container() {
  echo -e "\n* [CONFIGURATOR] setup db volume container"
  if container_exists "db-storage"; then return; fi

  docker run -d --name db-storage \
             postgres /bin/true
}


function setup_db_container() {
  echo -e "\n* [CONFIGURATOR] setup db container"
  if container_exists "db"; then 
    stop_and_remove_container db
  fi

  docker run -d --name db \
                -p 5432:5432 \
                --volumes-from db-storage \
                postgres
}


function setup_git_receiver_storage() {
  echo -e "\n* [CONFIGURATOR] setup git receiver storage"
  if container_exists "db-storage"; then return; fi

  docker run -d --name git-receiver-storage \
                git-receiver /bin/true
}


function setup_git_receiver() {
  echo -e "\n* [CONFIGURATOR] setup git receiver"
  if container_exists "git-receiver"; then 
    stop_and_remove_container git-receiver
  fi

  docker run -d --name git-receiver \
                -p 2222:22 \
                --volumes-from git-receiver-storage \
                -v /var/run/docker.sock:/var/run/docker.sock \
                -e "GIT_USER_PASSWORD=$GIT_USER_PASSWORD" \
                git-receiver
}


# private 
function stop_and_remove_container() {
  CONTAINER_NAME=$1

  # todo add some checks if container is running
  # to prevent displaying errors
  docker rm -f -v $CONTAINER_NAME
}

function container_exists() {
  ID=$(docker inspect --format="{{ .Id }}" $1 2> /dev/null)
  if [ -n "$ID" ]; then
    return 0; # 0 = true
  fi
  return 1; # 1 = false
}

# run!
main