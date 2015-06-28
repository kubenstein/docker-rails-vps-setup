#!/bin/bash
#
# this script builds app image,
# stops already running container and start new one.
#
# ONLY IF WE PUSH TO MASTER
#

function deploy_new_version() {
  echo "deploying new version"
}

#-------
while read oldrev newrev refname
do
    branch=$(git rev-parse --symbolic --abbrev-ref $refname)
    if [ "master" == "$branch" ]; then
        deploy_new_version
    fi
done