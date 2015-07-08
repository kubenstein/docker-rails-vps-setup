#
# This is configurator Dockerfile.
# It will build special config container with access to host docker deamon.
# Whole logic is in configurate.sh script

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

# add all files that are required to build basic containers
RUN mkdir image-files
ADD image-files/ image-files

# add script that will build and run all basic containers
ADD configurate.sh .
RUN chmod +x configurate.sh

CMD "./configurate.sh"