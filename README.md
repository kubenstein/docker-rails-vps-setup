VPS Setup
=============

This is my experimental vps setup based on docker.
Goal is to create simple vps servers configuration for my Rails and Node.js apps.

Requirements:

* Automatic VPS setup
* DB (Postgres in this case)
* Automatic and manual DB backuping  to s3.
* Easy restoring db from s3
* Git push based web app updating mechanism 
* Easy wiping and rebuilding all components
* Easy run command as an app eg. rake db:migrate

Instalation:
-------
To configure your vps just launch `bootstap.sh` script. After instaling Docker on your host, all containers setup is done by special `setup-contaiers-configuration` container.

Script will:

    1) upload setup files to vps
    2) create proper users
    3) install docker
    4) build and run configuration container.


Configuration container thanks to `-v /var/run/docker.sock:/var/run/docker.sock` will:

    1) Build and run Postgres data volume container
    2) Build and run Postgres db backup container 
    3) Build and run Postgres container
    4) Build and run Git receiver container

Usage:
-------
Git receiver will listen on port 2222 (22 is reserved for ssh to host machine itself), so config your git repo in this way:

    git remote add vps ssh://git@<host-ip>:2222/app.git
    git push vps master


TODO:
-------
- restoring db from s3 backup
- add monitoring
- add ability to have multiple app instnaces
