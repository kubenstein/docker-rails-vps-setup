#!/bin/bash
#
# this script builds app image from app source,
# stops already running container and start new one.
#

cd ~/app.git


function main() {
  rebuild_app_image
  stop_existing_app
  launch_new_version
}


function rebuild_app_image() {
  echo -e "\n* [BUILDER] building app image"
  docker build -t app-image .
}


function stop_existing_app() {
  echo -e "\n* [BUILDER] stoping exisitng app containers"
  APP_CONTAINERS=$(docker ps | grep "app-image" | cut -d' ' -f1)
  docker stop $APP_CONTAINERS
  docker rm -v $APP_CONTAINERS
}


function launch_new_version() {
  echo -e "\n* [BUILDER] launching new version"
  docker run -d --name app-01 \
                -p 80:3000 --link db \
                app-image
}


# run!
main