#!/bin/bash
#
# this script launch app updateing pipeline
# when new version of come has been pushed to repo
#
# only pushing to master branch will trigger rebuilding
#

function deploy_new_version() {
  ~/launch-new-version.sh
}

#-------
while read oldrev newrev refname
do
    branch=$(git rev-parse --symbolic --abbrev-ref $refname)
    if [ "master" == "$branch" ]; then
        deploy_new_version
    fi
done