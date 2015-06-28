#!/bin/bash
#
# this script set password for git user 
# (which is needed because on Docker build is impossible to reach ENV)
# and then runs ssh deamon.
#
echo "* changing git user pass"
echo "git:$GIT_USER_PASSWORD" | chpasswd

echo "* runnig ssh deamon"
/usr/sbin/sshd -D