#
# this is Dockerfile for git-receiver image
# container expose git repo via ssh and build 
# new app on git push.
#
# i think git-receiving and building should be separated
# into two independed containers.
# For now it is all here.
#

FROM debian:wheezy

ENV DEBIAN_FRONTEND noninteractive

ENV DOCKER_VERSION 1.6.2

RUN apt-get -qq update \
    && apt-get -qq install -y wget ca-certificates

# install docker cli
RUN wget https://get.docker.com/builds/Linux/x86_64/docker-$DOCKER_VERSION \
    && chmod +x docker-$DOCKER_VERSION \
    && mv docker-$DOCKER_VERSION /usr/local/bin/docker \
    && groupadd -g 999 docker

# install git server
RUN apt-get -qq install -y openssh-server git 

# setup ssh
RUN mkdir -p /var/run/sshd

# adding git user

RUN adduser --system --ingroup docker git
RUN sed -i "s#/home/git:/bin/false#/home/git:/bin/bash#" /etc/passwd

WORKDIR /home/git/

# do stuff as a git user
USER git

RUN mkdir -p /home/git/.ssh
RUN touch /home/git/.ssh/authorized_keys
RUN git init --bare app.git

# do stuff back as a root user
USER root
ADD post-receive-hook.sh app.git/hooks/post-receive
RUN chmod +x app.git/hooks/post-receive
RUN chown git app.git/hooks/post-receive

ADD launch-new-version.sh launch-new-version.sh
RUN chmod +x launch-new-version.sh
RUN chown git launch-new-version.sh

# link project git repo to root location
# just for convenience
RUN ln -s /home/git/app.git /app.git

# allow to persist public keys
VOLUME /home/git/.ssh

# Adding startup script
ADD git-receiver-startup.sh ./
RUN chmod +x git-receiver-startup.sh

EXPOSE 22

CMD ["./git-receiver-startup.sh"]