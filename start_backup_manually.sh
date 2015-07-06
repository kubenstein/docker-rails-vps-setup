#!/bin/bash
#
# This script will init db backup.
# Access via host user: docker-host.
# e.g HOST_IP=192.168.1.103 ; ./start_backup_manually.sh
#

function main() {
  check_for_necessary_variables

  ssh -t -t docker-host@$HOST_IP "docker run -d --volumes-from db-storage -v /etc/localtime:/etc/localtime:ro -e 'S3_BACKUP_BUCKET=$S3_BACKUP_BUCKET' -e 'S3_KEY=$S3_KEY' -e 'S3_SECRET=$S3_SECRET' db-backup-image ./create-backup.sh ; echo 'backup queued'"
}

function check_for_necessary_variables() {
  if [ -z "$HOST_IP" ]; then
    echo "*********** provide HOST_IP ***********"
    read HOST_IP
  fi

  if [ -z "$S3_BACKUP_BUCKET" ]; then
    echo "*********** provide S3_BACKUP_BUCKET ***********"
    read S3_BACKUP_BUCKET
  fi

  if [ -z "$S3_KEY" ]; then
    echo "*********** provide S3_KEY ***********"
    read S3_KEY
  fi

  if [ -z "$S3_SECRET" ]; then
    echo "*********** provide S3_SECRET ***********"
    read S3_SECRET
  fi
}


main