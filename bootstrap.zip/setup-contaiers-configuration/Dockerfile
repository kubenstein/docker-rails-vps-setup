#
# this is configurator Dockerfile
# it will build container with docker-cli
# then run configurate.sh

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

# add all files that are required to build basic containers
RUN mkdir image-files
ADD image-files/ image-files

# add script that will build and run all basic containers
ADD configurate.sh .
RUN chmod +x configurate.sh

CMD "./configurate.sh"