#!/usr/bin/env bash
set -x
source "$(dirname "$0")/common.bash"

[ "$(uname)" != "Darwin" ] && exit
[ -n "$SKIP_HOMEBREW" ] && exit

if type brew >/dev/null; then
    echo "Homebrew is already installed."
else
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
fi

echo "Updating Homebrew..."
brew update

echo "Installing some apps..."
brew bundle install --file "${REPO_DIR}/.config/homebrew/Brewfile" --no-lock --verbose

true
