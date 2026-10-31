curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
# Download kind directly from GitHub Releases (latest stable v0.33.0 or v0.24.0)
curl -Lo ./kind https://github.com/kubernetes-sigs/kind/releases/download/v0.33.0/kind-linux-amd64
chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind
