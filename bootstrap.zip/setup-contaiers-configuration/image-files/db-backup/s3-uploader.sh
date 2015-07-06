#!/bin/bash
#
# This script uploads file from the input to s3.
# S3_BACKUP_S3_BACKUP_BUCKET, S3_KEY, S3_SECRET env variables needs to be provided.
#
# ! WARNING: curl users --insecure flag
#

FILE_PATH=$@

FILE_NAME=$(basename $FILE_PATH)
RESOURCE="/$S3_BACKUP_BUCKET/$FILE_NAME"
DATE_VALUE=$(date +"%a, %d %b %Y %H:%M:%S %z")
CONTENT_TYPE="application/octet-stream"
MD5=$(openssl dgst -md5 -binary "$FILE_PATH" | base64)
STRING_TO_SIGN="PUT\n${MD5}\n${CONTENT_TYPE}\n${DATE_VALUE}\n${RESOURCE}"
SIGNATURE=$(echo -en ${STRING_TO_SIGN} | openssl sha1 -hmac ${S3_SECRET} -binary | base64)
echo $FILE_PATH
curl -# -X PUT -T "$FILE_PATH" \
     --insecure \
     -H "Host: ${S3_BACKUP_BUCKET}.s3.amazonaws.com" \
     -H "Date: ${DATE_VALUE}" \
     -H "Content-Type: ${CONTENT_TYPE}" \
     -H "Content-MD5: ${MD5}" \
     -H "Authorization: AWS ${S3_KEY}:${SIGNATURE}" \
     https://${S3_BACKUP_BUCKET}.s3.amazonaws.com/backups/${FILE_NAME}