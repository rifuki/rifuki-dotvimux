#!/bin/sh

set -e  # Exit immediately if a command exits with a non-zero status

# 1. Install required dependencies for Neovim and tmux
echo "==> Installing system dependencies..."
sudo apt update
sudo apt install -y curl git unzip build-essential cmake ninja-build gettext tmux zsh

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
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | sh

  # Load NVM for current script session
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

 # Add NVM init to .zshrc if not already present
  echo "==> Adding NVM init to .zshrc..."
  NVM_INIT='export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"'
  grep -qxF 'export NVM_DIR="$HOME/.nvm"' ~/.zshrc || echo "$NVM_INIT" >> ~/.zshrc

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

# 7. Install TPM (Tmux Plugin Manager) if not already present
TPM_DIR="$HOME/.config/tmux/plugins/tpm"
if [ ! -d "$TPM_DIR" ]; then
  echo "==> Cloning TPM (Tmux Plugin Manager)..."
  git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
else
  echo "==> TPM already installed, skipping."
fi

# 8. Install tmux plugins (no need for prefix + I)
echo "==> Installing tmux plugins via TPM..."
"$TPM_DIR/bin/install_plugins"

# 9. Setup Zsh and plugins
echo "==> Setting up Zsh and plugins..."

# Set zsh as default shell (if not already)
if [ "$SHELL" != "$(which zsh)" ]; then
  echo "==> Changing default shell to zsh..."
  chsh -s "$(which zsh)"
fi

# Install Oh My Zsh (non-interactive)
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "==> Installing Oh My Zsh..."
  RUNZSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# Install zsh plugins
ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"

# zsh-autosuggestions
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
  echo "==> Installing zsh-autosuggestions..."
  git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
fi

# zsh-syntax-highlighting
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
  echo "==> Installing zsh-syntax-highlighting..."
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
fi

# powerlevel10k theme
if [ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]; then
  echo "==> Installing powerlevel10k theme..."
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k"
fi

# Install zsh plugins
ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"

# zsh-autosuggestions
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
  echo "==> Installing zsh-autosuggestions..."
  git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
fi

# zsh-syntax-highlighting
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
  echo "==> Installing zsh-syntax-highlighting..."
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
fi

# powerlevel10k theme
if [ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]; then
  echo "==> Installing powerlevel10k theme..."
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k"
fi

# 10. Suggest zshrc configuration (manual or edit as needed)
echo "==> Please ensure your ~/.zshrc includes:"
echo '     ZSH_THEME="powerlevel10k/powerlevel10k"'
echo '     plugins=(git zsh-autosuggestions zsh-syntax-highlighting)'
echo '     [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh'

echo "==> All done!"
echo "👉 Please restart your terminal or log out & log in to use zsh and enjoy the full setup!"
