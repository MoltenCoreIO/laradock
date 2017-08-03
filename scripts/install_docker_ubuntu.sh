#!/bin/bash
# ================================================================== #
# install docker and add {USER} to docker group
# ================================================================== #
#
# USAGE: ./install_docker_ubuntu.sh {USER}
# DEFAULT: USER=root
# ================================================================== #
USER=${1:-root}

#Update apt and install docker-engine
curl -fsSL get.docker.com -o get-docker.sh

chmod +x get-docker.sh
./get-docker.sh

usermod -aG docker ${USER}

rm get-docker.sh

service docker restart