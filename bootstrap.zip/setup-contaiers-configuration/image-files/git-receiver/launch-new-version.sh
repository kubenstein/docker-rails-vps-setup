#!/bin/bash
#
# this script builds app image from app source,
# stops already running container and start new one.
#


function main() {
  clone_project_to_temp
  rebuild_app_image

  BUILD_EXIT_CODE=$?
  if [ $BUILD_EXIT_CODE == 0 ]; then
    stop_existing_app
    launch_new_version
  fi

  clean_temp
}


function clone_project_to_temp() {
  echo -e "\n* [BUILDER] creating project temp files"
  git clone /app.git /tmp/app-code
}


function clean_temp() {
  echo -e "\n* [BUILDER] removing temp project files"
  rm -rf /tmp/app-code
}


function rebuild_app_image() {
  echo -e "\n* [BUILDER] building app image"
  docker build -t app-image /tmp/app-code/
}


function stop_existing_app() {
  echo -e "\n* [BUILDER] stoping exisitng app containers"
  APP_CONTAINERS=$(docker ps | grep "app-image" | cut -d' ' -f1)
  if [ -n "$APP_CONTAINERS" ]; then
    docker stop $APP_CONTAINERS
    docker rm -v $APP_CONTAINERS
  fi
}


function launch_new_version() {
  echo -e "\n* [BUILDER] launching new version"
  docker run -d --name app-01 \
                -p 80:3000 --link db \
                app-image
}


# run!
main