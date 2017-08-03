#!/bin/bash
# ================================================================== #
# install - Debian or Ubuntu server
# ================================================================== #
#
# USAGE: ./install.sh {USER} {DOMAIN}
# DEFAULT: USER=root DOMAIN=moltencore.dev
# ================================================================== #
#          Define system specific details in this section            #
# ================================================================== #
#
USER=${1:-root}
DOMAIN=${2:-moltencore.dev}

echo "install with params: USER: $USER, DOMAIN: $DOMAIN"
# ================================================================== #
# Export variable to be used in other script and docker-composer
# ================================================================== #
export USER=$USER
export DOMAIN=$DOMAIN

# ================================================================== #
BASEDIR=$(dirname "$0")

# -------------------------------------------------------------------------
# install Docker
# -------------------------------------------------------------------------
echo
echo "Install Docker"
echo "---------------------------------------------------------------"
if ! type "docker" > /dev/null; then
    dist=`grep DISTRIB_ID /etc/*-release | awk -F '=' '{print $2}'`

    if [ "$dist" == "Ubuntu" ]; then
      echo "Installing Docker for ubuntu"
      $BASEDIR/install_docker_ubuntu.sh ${USER}
    else
      echo "not ubuntu: not handled yet"
      # @TODO
    fi
    echo "Docker installed and $USER added to docker group"
else
    echo "Docker already installed: $(docker --version)"
fi
echo "---------------------------------------------------------------"
#
# -------------------------------------------------------------------------
# install docker-compose
# -------------------------------------------------------------------------
echo
echo "Install docker-compose"
echo "---------------------------------------------------------------"
if ! type "docker-compose" > /dev/null; then
    $BASEDIR/install_docker-compose.sh
    echo
    echo "docker-compose installed"
else
    echo "Docker-compose already installed: $(docker-compose --version)"
fi
echo "---------------------------------------------------------------"
#
# -------------------------------------------------------------------------
# Init and Start all docker stack
# -------------------------------------------------------------------------
#
#
# Configure .env
# cp project_env $BASEDIR/../.env

# web application configure virtualhost
# cp project_virtualHost.conf $BASEDIR/../nginx/sites/${DOMAIN}.conf

# Start docker-compose stack with configured services
cd $BASEDIR/..
docker-compose up -d workspace php-fpm nginx mariadb phpmyadmin
# configure this ....
