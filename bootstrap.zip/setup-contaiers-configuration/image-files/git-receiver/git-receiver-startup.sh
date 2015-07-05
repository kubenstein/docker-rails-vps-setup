#!/bin/bash
#
# This script sets password for git user on runtime.
# (which is needed because on Docker build it is impossible to reach ENV)
# then starts ssh deamon
#
echo "* changing git user pass"
echo "git:$GIT_USER_PASSWORD" | chpasswd

echo "* runnig ssh deamon"
/usr/sbin/sshd -D