#!/bin/zsh

if [[ "$OSTYPE" != "darwin"* ]]; then
  echo "No macOS detected!"
  exit 1
fi

start() {
  clear


  echo "==========================================================="
  echo "        !! ATTENTION !!"
  echo "YOU ARE SETTING UP: DMFGO Environment (macOS)"
  echo "==========================================================="
  echo ""
  echo -n "* The setup will begin in 5 seconds... "

  sleep 5

  echo -n "Times up! Here we start!"
  echo ""

  cd $HOME
}

# xcode command tool will be installed during homebrew installation
install_homebrew() {
  echo "==========================================================="
  echo "                     Install Homebrew                      "
  echo "-----------------------------------------------------------"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
}

install_packages() {
  # Only install required packages for setting up enviroments
  # Later we will call brew bundle
  __pkg_to_be_installed=(
    curl
    git
    jq
    wget
    zsh
  )

  echo "==========================================================="
  echo "* Install following packages:"
  echo ""

  for __pkg ($__pkg_to_be_installed); do
    echo "  - ${__pkg}"
  done

  echo "-----------------------------------------------------------"

  brew update

  for __pkg ($__pkg_to_be_installed); do
    brew install ${__pkg} || true
  done
}

clone_repo() {
  echo "-----------------------------------------------------------"
  echo "* Cloning DMFGO/dotfiles Repo from GitHub.com"
  echo "-----------------------------------------------------------"

  git clone https://github.com/viviethoang99/dotfiles.git

  cd ./dotfiles
  rm -rf .git
}

setup_omz() {
  echo "==========================================================="
  echo "                      Shells Enviroment"
  echo "-----------------------------------------------------------"
  echo "* Installing Oh-My-Zsh..."
  echo "-----------------------------------------------------------"

  curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh | bash

  echo "-----------------------------------------------------------"
  echo "* Installing ZSH Custom Plugins & Themes:"
  echo ""
  echo "  - zsh-autosuggestions"
  echo "  - fast-syntax-highlighting"
  echo "  - p10k zsh-theme"
  echo "  - zsh-z"
  echo "-----------------------------------------------------------"

  git clone https://github.com/Aloxaf/fzf-tab ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/fzf-tab
  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
  git clone https://github.com/zdharma/fast-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting
  git clone https://github.com/mafredri/zsh-async.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-async
  git clone https://github.com/agkozak/zsh-z ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-z

  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
}

brew_bundle() {
  printf "\n--- Installing shell packages ---\n"
  brew bundle --file="~/dotfiles/brewfiles/Brewfile-shell"

  printf "\n--- Installing languages from homebrew ---\n"
  brew bundle --file="~/dotfiles/brewfiles/Brewfile-lang"

  printf "\n--- Installing others packages ---\n"
  brew bundle --file="~/dotfiles/brewfiles/Brewfile-others"

  printf "\n--- Installing apps by Homebrew-Cask.. ---\n"
  brew bundle --file="~/dotfiles/brewfiles/Brewfile-cask"

  printf "\n--- Installing apps by mas.. ---\n"
  brew install mas
  brew bundle --file="~/dotfiles/brewfiles/Brewfile-mas"
}

install-goenv() {
  echo "==========================================================="
  echo "                   Install syndbg/goenv"
  echo "-----------------------------------------------------------"

  git clone https://github.com/syndbg/goenv.git $HOME/.goenv
}

zshrc() {
  echo "==========================================================="
  echo "                  Import DMFGO env zshrc                   "
  echo "-----------------------------------------------------------"

  cat $HOME/dotfiles/_zshrc/macos.zshrc > $HOME/.zshrc
  cat $HOME/dotfiles/p10k/.p10k.zsh > $HOME/.p10k.zsh
}

fix_home_end_keybinding() {
  mkdir -p $HOME/Library/KeyBindings/
  echo "{
    \"\UF729\"  = moveToBeginningOfLine:; // home
    \"\UF72B\"  = moveToEndOfLine:; // end
    \"$\UF729\" = moveToBeginningOfLineAndModifySelection:; // shift-home
    \"$\UF72B\" = moveToEndOfLineAndModifySelection:; // shift-end
  }" > $HOME/Library/KeyBindings/DefaultKeyBinding.dict
}

finish() {
  echo "==========================================================="
  echo -n "* Clean up..."

  cd $HOME
  rm -rf $HOME/dotfiles

  echo "Done!"
  echo ""
  echo "> DMFGO Enviroment Setup finished!"
  echo "> Do not forget run those things:"
  echo ""
  echo "- chsh -s /usr/bin/zsh"
  echo "- ci-edit-update"
  echo "- oload-config"
  echo "- git-config"
  echo "* open vim and run :PlugInstall"
  echo "==========================================================="

  cd $HOME
}

start
install_homebrew
install_packages
setup_omz
brew_bundle
ioio
fix_home_end_keybinding
zshrc
finish