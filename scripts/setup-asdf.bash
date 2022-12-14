#!/usr/bin/env bash
set -x
source "$(dirname "$0")/common.bash"

if [ -d "$XDG_DATA_HOME/asdf" ]; then
    echo "asdf-vm is already installed."
    source "$XDG_DATA_HOME/asdf/asdf.sh"

    echo "Updating asdf-vm plugins..."
    asdf update
    asdf plugin update --all
else
    echo "Installing asdf-vm..."
    git clone "https://github.com/asdf-vm/asdf" "$XDG_DATA_HOME/asdf"
    source "$XDG_DATA_HOME/asdf/asdf.sh"

    echo "Installing asdf-vm plugins..."
    asdf plugin add nodejs
fi
