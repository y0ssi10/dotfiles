#!/usr/bin/env bash
set -x
source "$(dirname "$0")/common.bash"

[ "$(uname)" != "Darwin" ] && exit
[ -n "$SKIP_HOMEBREW" ] && exit

# Install Rosetta 2 for Apple Silicon
if [ "$(uname -m)" = "arm64" ] ; then
  /usr/sbin/softwareupdate --install-rosetta --agree-to-license
fi


if type brew >/dev/null; then
    echo "Homebrew is already installed."
else
    echo "Installing Xcode..."
    xcode-select --install

    echo "Installing Homebrew..."

    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
    if [ "$(uname -m)" = "arm64" ]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
        export PATH="/opt/homebrew/bin:$PATH"
    else
        eval "$(/usr/local/bin/brew shellenv)"
    fi
fi

echo "Updating Homebrew..."
brew update

echo "Installing some apps..."
brew bundle install --file "${REPO_DIR}/.config/homebrew/Brewfile" --no-lock --verbose

true
