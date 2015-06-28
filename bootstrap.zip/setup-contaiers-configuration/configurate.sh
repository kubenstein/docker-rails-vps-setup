#!/bin/bash
#
# This script is lauch inside configuration container
# It will create all basic containers on the host mashine
#

# create db volume container
echo "[CONFIGURATOR] setup db volume container"
docker run -d --name db-storage \
              postgres /bin/true


# create db container
echo "[CONFIGURATOR] setup db container"
docker run -d --name db \
              -p 5432:5432 \
              --volumes-from db-storage \
              postgres


# create git keys storage
echo "[CONFIGURATOR] setup git receiver storage"
docker build -t git-receiver ./image-files/git-receiver

docker run -d --name git-receiver-storage \
              git-receiver /bin/true


echo "[CONFIGURATOR] setup git receiver"
docker run -d --name git-receiver \
              -p 2222:22 \
              --volumes-from git-receiver-storage \
              -v /var/run/docker.sock:/var/run/docker.sock \
              -e "GIT_USER_PASSWORD=$GIT_USER_PASSWORD" \
              git-receiver