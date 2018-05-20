#!/bin/bash

# Configuration
echo "* $(basename "$0")"
echo "- Configuration:"
if [ -z "$1" ]; then config_docker_channel="edge"; else config_docker_channel="$1"; fi
echo "1- config_docker_channel: ${config_docker_channel}"
if [ -z "$2" ]; then config_docker_compose_version="1.16.1"; else config_docker_compose_version="$2"; fi
echo "2- config_docker_compose_version: ${config_docker_compose_version}"

# Setup - Go to the directory where the bash file is
call_dir=$(pwd)
cd "$(dirname "$0")"
bash_dir=$(pwd)
echo "- Called from ${call_dir}"
echo "- Running from ${bash_dir}"
cd "$(dirname "$0")"

# Ensure that run as root
if [ "$EUID" -ne 0 ]
  then echo "This program must be run with administrator privileges.  Aborting"
  exit
fi

# Exit on any non-zero status.
trap 'exit' ERR
set -E

# Instructions
echo "- Update the apt package index."
apt-get update

echo "- Install packages to allow apt to use a repository over HTTPS."
apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common

echo "- Add Docker's official GPG key."
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

echo "- Verify the fingerprint."
apt-key fingerprint 0EBFCD88

echo "- Pick the release channel."
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) ${config_docker_channel}"

echo "- Update the apt package index."
apt-get update

echo "- Install the latest version of Docker CE."
apt-get install -y docker-ce

echo "- Allow your user to access the Docker CLI without needing root."
usermod -aG docker $USER

echo "- Install Docker Compose."
curl -L https://github.com/docker/compose/releases/download/${config_docker_compose_version}/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose &&
chmod +x /usr/local/bin/docker-compose

echo "- Additional intructions"
echo " Add the following commands on your ~/.bashrc :"
echo "    # configure docker"
echo "    export DOCKER_HOST=tcp://192.168.99.100:2376"
echo "    export DOCKER_CERT_PATH=/mnt/c/Users/roger/.docker/machine/certs"
echo "    export DOCKER_TLS_VERIFY=1"

# Setup - Return to the called directory
cd "${call_dir}"

