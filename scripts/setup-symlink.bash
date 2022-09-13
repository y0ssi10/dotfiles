#!/usr/bin/env bash
set -x
source "$(dirname "$0")/common.bash"

if [ ! -d "$HOME/.ssh" ]; then
    mkdir -p "$HOME/.ssh"
    chmod 700 "$HOME/.ssh"
fi

if [ ! -d "$HOME/.gnupg" ]; then
    mkdir -p "$HOME/.gnupg"
    chmod 700 "$HOME/.gnupg"
fi

mkdir -p \
    "$XDG_CONFIG_HOME" \
    "$XDG_STATE_HOME" \
    "$XDG_DATA_HOME"

ln -sfv "$REPO_DIR/.config/"* "$XDG_CONFIG_HOME"
ln -sfv "$XDG_CONFIG_HOME/zsh/.zshenv" "$HOME/.zshenv"
ln -sfv "$XDG_CONFIG_HOME/zsh/.zshrc" "$HOME/.zshrc"

ln -sfv "$XDG_CONFIG_HOME/starship/starship.toml" "$HOME/.config/starship.toml"

ln -sfv "$XDG_CONFIG_HOME/asdf/.asdfrc" "$HOME/.asdfrc"
ln -sfv "$XDG_CONFIG_HOME/asdf/.tool-versions" "$HOME/.tool-versions"
