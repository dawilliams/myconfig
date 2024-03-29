#!/bin/zsh

################################################
# functions
################################################
download_homebrew_install_file() {
  homebrew_install_file="/tmp/homebrew-install.sh"
  if [ ! -f "$homebrew_install_file" ]; then
    curl -sSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh -o "$homebrew_install_file"
  fi
  echo "Homebrew install script located at $homebrew_install_file"
}

ask_if_user_wants_to_continue() {
  echo "Would you like to exit and review the HomeBrew script? (y,n,yes,no) "
  read -r read_script
  case ${read_script} in
    n | N | No | no)
      echo "Continuing script..."
      chmod u+x "$homebrew_install_file"
      "$homebrew_install_file"
    ;;
    *)
      echo "Exiting script. Rerun script when you are ready to continue."
      echo "If using vim to read the file, turn on syntax highlighting with 'syntax on'"
      exit 0
    ;;
  esac
}

install_homebrew_bash() {
  echo "Installing Bash with HomeBrew"
  brew install bash
}

set_default_shell() {
  echo "\nUpdating /etc/shells..."
  sudo tee -a /etc/shells > /dev/null << EOF
/usr/local/bin/bash
EOF
  echo "Setting default shell to HomeBrew Bash."
  chsh -s /usr/local/bin/bash
}

install_homebrew_git() {
  echo "Installing Git with HomeBrew..."
  brew install git
}

################################################
# script
################################################
echo "Checking for HomeBrew..."
if ! which brew &> /dev/null; then
  download_homebrew_install_file
  ask_if_user_wants_to_continue
else
  echo "Found Homebrew. Skipping."
fi

echo "\nChecking for HomeBrew Bash..."
if ! brew list bash &> /dev/null; then
  install_homebrew_bash
  set_default_shell
else
  echo "Found Homebrew Bash. Skipping."
fi

echo "\nChecking for Git..."
if ! which git &> /dev/null; then
  install_homebrew_git
else
  echo "Found Git. Skipping."
fi

echo "\nChecking for Git myconfig respository"
local GIT_DIR="${HOME}/.myconfig"
if ! git -C $GIT_DIR rev-parse --is-bare-repository &> /dev/null; then
  git clone --bare https://github.com/dawilliams/myconfig.git $HOME/.mycfg
else
  echo "Found myconfig Git repository. Skipping."
fi


echo "\nChecking out Git myconfig respository"
git  --git-dir=$HOME/.mycfg/ --work-tree=$HOME checkout
