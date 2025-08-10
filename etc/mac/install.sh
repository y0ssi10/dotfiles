#!/bin/bash

XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"

DOT_DIR="${DOT_DIR:-${HOME}/workspace/github.com/y0ssi10/dotfiles}"

ln -sfv "$XDG_CONFIG_HOME/zsh/.zshenv" "$HOME/.zshenv"

echo ""
echo "  Next step: Download Xcode from AppStore."
echo "  After download, run commands below to setup applications."
echo ""
echo "  sudo xcodebuild -license"
echo "  xcode-select --install"
echo "  (for Apple Silicon Mac) sudo softwareupdate --install-rosetta"
echo "  bash ${DOT_DIR}/etc/mac/setup-homebrew.sh"
