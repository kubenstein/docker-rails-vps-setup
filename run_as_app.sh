#!/bin/bash
#
# This script will run command as an app container.
# Access via host user: docker-host.
# e.g HOST_IP=192.168.1.103 ; ./run_as_app.sh rake db:migrate
#

function main() {
  COMMAND=$@
  if [ -z "$COMMAND" ]; then
    echo "!! no command given"
    exit
  fi

  check_for_necessary_variables

  ssh -t -t docker-host@$HOST_IP "docker run --rm -it --link db:db app-image $COMMAND"
}


function check_for_necessary_variables() {
  if [ -z "$HOST_IP" ]; then
    echo "*********** provide HOST_IP ***********"
    read HOST_IP
  fi
}


main $@