# 1.
sudo apt update
sudo apt install -y ca-certificates curl

# 2. 
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# 3. 
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# 4.
sudo apt update

# 5. install common docker packages 

sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# 6 install docker scout

curl -fsSL https://raw.githubusercontent.com/docker/scout-cli/main/install.sh -o install-scout.sh

chmod +x install-scout.sh

# to install it in the common directory for all docker commands

sudo sh install-scout.sh -b /usr/libexec/docker/cli-plugins

rm -vrf install-scout.sh

# 7 to run docker with current user , not with sudo privilege only

sudo usermod -aG docker $USER

echo "All docker packages are installed successfully (Y)"
