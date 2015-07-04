#!/bin/bash
#
# this script copies all nesesry files to remote server
# and initializes bootstrap process.
#
set -e

# swtich to script location
SCRIPT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd $SCRIPT_DIR


function main() {
  gather_credentials
  copy_files
  initialize_process
}


function gather_credentials() {
  echo "*********** provide host ip ***********"
  read HOST_IP

  echo "*********** provide host root user ***********"
  read HOST_ROOT_USER
}


function copy_files() {
  echo "* copy files to $HOST_IP"
  scp -r bootstrap.zip/ $HOST_ROOT_USER@$HOST_IP:~/
}


function initialize_process() {
  echo "* ssh to $HOST_IP to initialize setup"
  ssh -t $HOST_ROOT_USER@$HOST_IP 'sudo sh -c "cp -R ~/bootstrap.zip /usr/shared/ && sleep 5 && /usr/shared/bootstrap.zip/setup.sh"'
}


# run!
main