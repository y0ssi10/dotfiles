#!/bin/bash

XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"

# echo "  create symlink to homebrew directory."
# https://stackoverflow.com/questions/65259300/detect-apple-silicon-from-command-line
# if [[ "$(uname -m)" == 'arm64' ]]; then
#   ln -sf "/opt/homebrew" "$HOME/homebrew"
# else
#   ln -sf "/usr/local" "$HOME/homebrew"
# fi

ln -sfv "$XDG_CONFIG_HOME/zsh/.zshenv" "$HOME/.zshenv"

# echo "  enable key-repeating for VScodeVim."
# defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false         # For VS Code
# defaults write com.microsoft.VSCodeInsiders ApplePressAndHoldEnabled -bool false # For VS Code Insider
# defaults write com.visualstudio.code.oss ApplePressAndHoldEnabled -bool false    # For VS Codium

echo ""
echo "  Next step: Download Xcode from AppStore."
echo "  After download, run commands below to setup applications."
echo ""
echo "  sudo xcodebuild -license"
echo "  xcode-select --install"
echo "  (for Apple Silicon Mac) sudo softwareupdate --install-rosetta"
echo "  bash ~/dotfiles/etc/mac/setup-brew.sh"
