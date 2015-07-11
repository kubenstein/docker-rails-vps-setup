#
# This is Dockerfile for git-receiver image.
# The container will exposes git repo via ssh.
# new app will be built on git push.
#

FROM debian:wheezy

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -qq update \
    && apt-get -qq install -y wget ca-certificates

ENV DOCKER_VERSION 1.7.0

# install docker cli
RUN wget https://get.docker.com/builds/Linux/x86_64/docker-$DOCKER_VERSION \
    && chmod +x docker-$DOCKER_VERSION \
    && mv docker-$DOCKER_VERSION /usr/local/bin/docker \
    && groupadd -g 999 docker

# install git server
RUN apt-get -qq install -y openssh-server git \
 # setup ssh
 && mkdir -p /var/run/sshd \
 # add git user
 && adduser --system --ingroup docker git \
 && sed -i "s#/home/git:/bin/false#/home/git:/bin/bash#" /etc/passwd

WORKDIR /home/git/

# create git bare repo 
USER git

RUN mkdir -p /home/git/.ssh \
 && touch /home/git/.ssh/authorized_keys \
 && mkdir -p /home/git/code/ \
 && git init --bare code/app.git

# add git hooks files
USER root
ADD post-receive-hook.sh code/app.git/hooks/post-receive
ADD launch-new-version.sh launch-new-version.sh
ADD git-receiver-startup.sh ./

RUN chmod +x code/app.git/hooks/post-receive \
 && chown git code/app.git/hooks/post-receive \
 && chmod +x launch-new-version.sh \
 && chown git launch-new-version.sh \
 && chmod +x git-receiver-startup.sh \
 # link git repo to root location, just for convinience
 && ln -s /home/git/code/app.git /app.git


# store app code in external container
VOLUME /home/git/code/

EXPOSE 22

CMD ["./git-receiver-startup.sh"]