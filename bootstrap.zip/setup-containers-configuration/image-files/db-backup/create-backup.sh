#!/bin/bash
#
# This script is responisble for create db backup
#

function main() {
  generate_db_dump
  upload_to_s3
  remove_tmp
}


function generate_db_dump() {
  local DATE=$(date +"%F_%H-%M")
  mkdir -p /tmp/backup/
  tar cvf /tmp/backup/backup-$DATE.tar /var/lib/postgresql/data
}


function upload_to_s3() {
  echo "start uploading $FILE_NAME"
  local FILE_NAME=$(ls -d1 /tmp/backup/*)
  ./s3-uploader.sh $FILE_NAME
  echo "uploaded $FILE_NAME"
}


function remove_tmp() {
  rm -r /tmp/backup/
}


# run!
main