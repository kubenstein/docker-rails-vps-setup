#!/bin/bash
#
# This script is responisble for periodically upload database dump to s3 
#

function main() {
  while true ; do
    generate_db_dump
    upload_to_s3
    remove_tmp
    wait_for_next_backup
  done
}


function generate_db_dump() {
  DATE=$(date +%F)
  mkdir -p /tmp/backup/
  tar cvf /tmp/backup/backup-$DATE.tar /var/lib/postgresql/data
}


function upload_to_s3() {
  FILE_NAME=$(ls -d1 /tmp/backup/*)
  ./s3-uploader.sh $FILE_NAME
  echo "uploaded $FILE_NAME"
}


function wait_for_next_backup() {
  sleep 86400 # 24h
}


function remove_tmp() {
  rm -r /tmp/backup/
}


# run!
main