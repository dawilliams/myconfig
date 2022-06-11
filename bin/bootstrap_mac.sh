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
if ! which brew; then
  download_homebrew_install_file
  ask_if_user_wants_to_continue
else
  echo "Found Homebrew. Skipping."
fi

echo "\nChecking for Git..."
if ! which git; then
  install_homebrew_git
else
  echo "Found Git. Skipping."
fi
