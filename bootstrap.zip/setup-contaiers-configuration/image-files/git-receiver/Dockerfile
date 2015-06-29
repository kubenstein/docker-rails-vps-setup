FROM debian:wheezy

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -qq update \
    && apt-get -qq install -y openssh-server git 

# setup ssh
RUN mkdir -p /var/run/sshd

# adding git user
RUN adduser --system git
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