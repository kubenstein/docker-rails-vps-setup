#!/bin/bash
#
# This script launches app updating pipeline on git push.
#
# Only pushing to master branch will trigger rebuilding.
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