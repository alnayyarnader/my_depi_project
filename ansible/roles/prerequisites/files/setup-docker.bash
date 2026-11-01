#!/bin/bash

# Exit immediately if any command exits with a non-zero status
set -e

echo "Starting Docker installation..."

# 1. Set up keyrings directory and download Docker's official GPG key
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# 2. Set up the stable repository
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# 3. Update local package index with the new Docker repo
sudo apt-get update -y

# 4. Install common Docker packages
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "Docker installed successfully!"

# 5. install docker scout

curl -fsSL https://raw.githubusercontent.com/docker/scout-cli/main/install.sh -o install-scout.sh

chmod +x install-scout.sh

# to install Docker scout in the common directory for all docker commands

sudo sh install-scout.sh -b /usr/libexec/docker/cli-plugins

rm -vrf install-scout.sh

# 6. to run docker with current user , not with sudo privilege only

sudo usermod -aG docker $USER

echo "Now, All docker packages are installed successfully (Y)"

echo "Doing post checks that everything is fine"


dpkg -l | grep docker
getent group docker
which docker
docker --version
sudo systemctl status docker
docker scout version
