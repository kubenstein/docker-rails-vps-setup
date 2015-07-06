#!/bin/bash
#
# This script is responisble for periodically create db backup
#

function main() {
  while true ; do
    wait_for_next_backup
    ./create-backup.sh
  done
}


function wait_for_next_backup() {
  sleep 86400 # 24h
}

# run!
main