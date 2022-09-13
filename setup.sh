#!/bin/sh
INSTALL_DIR="${INSTALL_DIR:-$PWD/dotfiles}"

if [ -d "$INSTALL_DIR" ]; then
    echo "Updating dotfiles..."
    git -C "$INSTALL_DIR" pull
else
    echo "Installing dotfiles..."
    git clone https://github.com/y0ssi10/dotfiles "$INSTALL_DIR"
fi

/bin/bash "$INSTALL_DIR/scripts/setup.bash"
