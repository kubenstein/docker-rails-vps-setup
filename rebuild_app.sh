#!/bin/bash
#
# This script will rebuild and restart app container.
# Access via host user: docker-host.
# e.g HOST_IP=192.168.1.103 ; ./rebuild_app.sh
#

function main() {
  check_for_necessary_variables
  ssh -t -t docker-host@$HOST_IP "docker run -it --rm --volumes-from git-receiver-storage -v /var/run/docker.sock:/var/run/docker.sock git-receiver-image ./launch-new-version.sh"
}


function check_for_necessary_variables() {
  if [ -z "$HOST_IP" ]; then
    echo "*********** provide HOST_IP ***********"
    read HOST_IP
  fi
}


main