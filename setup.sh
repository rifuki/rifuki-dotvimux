#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status

# 1. Install required dependencies
echo "==> Installing system dependencies..."
sudo apt update
sudo apt install -y curl git unzip build-essential cmake ninja-build gettext tmux zsh

# 2. Install Neovim
if ! command -v nvim &>/dev/null; then
  echo "==> Building Neovim from source..."
  git clone https://github.com/neovim/neovim.git
  cd neovim
  make CMAKE_BUILD_TYPE=RelWithDebInfo
  sudo make install
  cd ..
  rm -rf neovim
else
  echo "==> Neovim already installed, skipping."
fi

# 3. Install Node.js via NVM
if ! command -v npm &>/dev/null; then
  echo "==> Installing Node.js via NVM..."
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash

  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

  echo "==> Adding NVM init to .zshrc..."
  NVM_INIT='export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"'
  grep -qxF 'export NVM_DIR="$HOME/.nvm"' ~/.zshrc || echo "$NVM_INIT" >> ~/.zshrc

  nvm install 22
else
  echo "==> npm already installed, skipping."
fi

# 4. Clone dotfiles
echo "==> Cloning rifuki-dotvimux config repository..."
git clone https://github.com/rifuki/rifuki-dotvimux.git

echo "==> Cleaning old config files..."
rm -rf ~/.config/.git ~/.config/.gitignore ~/.config/nvim ~/.config/tmux

echo "==> Copying configuration files to ~/.config/ ..."
mkdir -p ~/.config
cp -r rifuki-dotvimux/. ~/.config/
rm -rf rifuki-dotvimux

# 5. Install TPM
TPM_DIR="$HOME/.config/tmux/plugins/tpm"
if [ ! -d "$TPM_DIR" ]; then
  echo "==> Installing TPM..."
  git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
fi

echo "==> Installing tmux plugins..."
"$TPM_DIR/bin/install_plugins"

# 6. Setup Zsh
echo "==> Setting up Zsh and Oh My Zsh..."

if [ ! -d "$HOME/.oh-my-zsh" ]; then
  RUNZSH=no KEEP_ZSHRC=yes bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

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
  echo "==> Installing powerlevel10k..."
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k"
fi

# 7. Configure .zshrc
echo "==> Updating .zshrc..."
touch ~/.zshrc

grep -qxF 'ZSH_THEME="powerlevel10k/powerlevel10k"' ~/.zshrc || \
  echo 'ZSH_THEME="powerlevel10k/powerlevel10k"' >> ~/.zshrc

grep -qxF 'plugins=(git zsh-autosuggestions zsh-syntax-highlighting)' ~/.zshrc || \
  echo 'plugins=(git zsh-autosuggestions zsh-syntax-highlighting)' >> ~/.zshrc

grep -qxF '[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh' ~/.zshrc || \
  echo '[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh' >> ~/.zshrc

# 8. Set Zsh as default shell
if [ "$SHELL" != "$(which zsh)" ]; then
  echo "==> Setting Zsh as default shell..."
  chsh -s "$(which zsh)"
fi

# 9. Done!
echo "==> ✅ Setup complete!"
echo "👉 Restart your terminal or run \`exec zsh\` to use your new environment."
