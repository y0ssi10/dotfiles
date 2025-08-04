#!/bin/bash

DOT_DIR="${DOT_DIR:-${HOME}/workspace/github.com/y0ssi10/dotfiles}"

die() {
  echo "$1"
  echo "  terminated."
  exit 1
}

brew_list="${DOT_DIR}/etc/mac/Brewfile"

which curl >> /dev/null || die "curl is required."
which brew >> /dev/null || /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
which brew >> /dev/null || die "brew is required."
# git -C $(brew --repo homebrew/core) checkout master
eval "$(/opt/homebrew/bin/brew shellenv)"
brew doctor || die "brew doctor raised error."

echo "  Updating Homebrew..."
brew update

if [ -e "$brew_list" ]; then
  echo "  Installing some apps..."
   brew bundle install --file="$brew_list"
else
  echo "  Brewfile is needed."
fi
brew cleanup
