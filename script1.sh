#!/bin/bash

sudo apt update
sudo apt install btrfs-progs -y
sudo dd if=/dev/zero of=/btrfs.img bs=1M count=40960
sudo mkfs.btrfs -f /btrfs.img
sudo mkdir /mnt/btrfs
sudo mount -o loop /btrfs.img /mnt/btrfs
sudo btrfs property set /mnt/btrfs compression zstd

# Add entry to /etc/fstab
echo "/btrfs.img $HOME btrfs loop,compress=zstd 0 0" | sudo tee -a /etc/fstab

# Add entry to /etc/wsl.conf
sudo bash -c 'cat <<EOF >> /etc/wsl.conf
[automount]
mountFsTab=true
EOF'

cd /
sudo umount $HOME
sudo mount -a

sudo chown -R $USER:$USER $HOME
# Update package list and install Zsh
sudo apt update
sudo apt install -y zsh

# Install Oh My Zsh
RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install Zsh Autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# Install Zsh Syntax Highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# Enable plugins in .zshrc
sed -i 's/plugins=(git)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting)/' ~/.zshrc

# Install NVM (Node Version Manager)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash

# Load NVM and install Node.js version 22
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
nvm install 22
nvm alias default 22

echo "Installation complete! Zsh, Oh My Zsh, Zsh Autosuggestions, Zsh Syntax Highlighting, and Node.js 22 are set up."

# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl -y
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo usermod -aG docker $USER
sudo systemctl start docker
echo '{"data-root": "$HOME/docker"}' | sudo tee /etc/docker/daemon.json
sudo systemctl restart docker
echo 'setting docker permissions to $HOME/docker'
sudo chown -R root:docker $HOME/docker
sudo chmod -R 700 $HOME/docker
echo 'checking docker info'
docker info | grep "Docker Root Dir"
echo 'installing gh'
sudo apt install -y gh

# Add environment variables to ~/.zshrc
echo "export DOTNET_ROOT=\$HOME/dotnet" | tee -a ~/.zshrc
echo "export PATH=\$PATH:\$HOME/dotnet" | tee -a ~/.zshrc
echo "export PATH=\$PATH:\$HOME/.dotnet/tools" | tee -a ~/.zshrc

# Add environment variables to ~/.bashrc
echo "export DOTNET_ROOT=\$HOME/dotnet" | tee -a ~/.bashrc
echo "export PATH=\$PATH:\$HOME/dotnet" | tee -a ~/.bashrc
echo "export PATH=\$PATH:\$HOME/.dotnet/tools" | tee -a ~/.bashrc

# Create symbolic links for .NET installation
sudo ln -s $HOME/dotnet /usr/local/share/dotnet
sudo ln -s $HOME/dotnet/dotnet /usr/local/bin/dotnet

# Change the default shell to Zsh at the end of the script
chsh -s $(which zsh)
zsh
