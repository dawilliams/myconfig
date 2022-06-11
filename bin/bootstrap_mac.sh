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

echo "\nChecking for Git..."
if ! which git &> /dev/null; then
  install_homebrew_git
else
  echo "Found Git. Skipping."
fi

echo "\nChecking for Git myconfig respository"
local GIT_DIR="${HOME}/.myconfig"
if ! git -C $GIT_DIR rev-parse --is-bare-repository &> /dev/null; then
  git clone --bare https://github.com/dawilliams/myconfig.git $HOME/.myconfig
else
  echo "Found myconfig Git repository. Skipping."
fi
