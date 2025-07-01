#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status

# 1. Install required dependencies for Neovim and tmux
echo "==> Installing system dependencies..."
sudo apt update
sudo apt install -y curl git unzip build-essential cmake ninja-build gettext

# 2. Build and install Neovim from source if not already installed
if ! command -v nvim &>/dev/null; then
  echo "==> Building and installing Neovim from source..."
  git clone https://github.com/neovim/neovim.git
  cd neovim
  make CMAKE_BUILD_TYPE=RelWithDebInfo
  sudo make install
  cd ..
  rm -rf neovim
else
  echo "==> Neovim already installed, skipping build."
fi

# 3. Install Node.js & npm via NVM (recommended)
if ! command -v npm &>/dev/null; then
  echo "==> Installing Node.js & npm via NVM..."
  # Install NVM
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
  # Load NVM for current script session
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  # Install Node.js LTS (V22)
  nvm install 22
  # Verify install
  node -v
  nvm current
  npm -v
else
  echo "==> npm already installed, skipping."
fi

# 4. Clone dotfiles repository
echo "==> Cloning rifuki-dotvimux config repository..."
git clone https://github.com/rifuki/rifuki-dotvimux.git

# 5. Remove conflicting config files/folders
echo "==> Cleaning existing configs from ~/.config/ ..."
rm -rf ~/.config/.git ~/.config/.gitignore ~/.config/nvim ~/.config/tmux

# 6. Copy configuration files to ~/.config/
echo "==> Copying configuration files to ~/.config/ ..."
mkdir -p ~/.config
cp -r rifuki-dotvimux/. ~/.config/
rm -rf rifuki-dotvimux

# 7. Install tmux if not already installed
if ! command -v tmux &>/dev/null; then
  echo "==> Installing tmux..."
  sudo apt update
  sudo apt install -y tmux
else
  echo "==> tmux already installed, skipping."
fi

# 8. Install TPM (Tmux Plugin Manager) if not already present
TPM_DIR="$HOME/.config/tmux/plugins/tpm"
if [ ! -d "$TPM_DIR" ]; then
  echo "==> Cloning TPM (Tmux Plugin Manager)..."
  git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
else
  echo "==> TPM already installed, skipping."
fi

# 9. Install tmux plugins (no need for prefix + I)
echo "==> Installing tmux plugins via TPM..."
"$TPM_DIR/bin/install_plugins"

echo "==> All done! Please run 'source ~/.bashrc' or open a new terminal so Node.js & npm are available."
