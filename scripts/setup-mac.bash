#!/usr/bin/env bash
set -x
source "$(dirname "$0")/common.bash"

[ "$(uname)" != "Darwin" ] && exit

touch "$HOME/.hushlogin"

# GPG
ln -sfv "$REPO_DIR/.config/gnupg/gpg-agent.conf" "$HOME/.gnupg/gpg-agent.conf"

# Finder
defaults write com.apple.finder DisableAllAnimations -bool true
defaults write com.apple.finder AppleShowAllFiles -bool true
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowTabView -bool true
defaults write com.apple.finder NewWindowTarget -string PfHm
defaults write com.apple.finder AnimateInfoPanes -bool false
defaults write -g NSScrollViewRubberbanding -bool false

# Keyboard
defaults write -g AppleKeyboardUIMode -int 3
defaults write -g InitialKeyRepeat -int 10
defaults write -g KeyRepeat -int 1

# Trackpad
defaults write -g AppleEnableSwipeNavigateWithScrolls -boolean true
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerHorizSwipeGesture -int 0
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerVertSwipeGesture -int 0

# Dock
defaults write com.apple.dock orientation right
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock tilesize -int 50
defaults write com.apple.dock magnification -bool false
defaults write com.apple.dock show-recents -bool false

# Menubar
defaults write com.apple.menuextra.battery ShowPercent -bool true
defaults write com.apple.menuextra.clock DateFormat -string "MMM d  H:mm:ss"

# Mission Control
defaults write com.apple.dock wvous-br-corner -int 4 # Bottom right -> Desktop
defaults write com.apple.dock mru-spaces -bool false # Don't automatically rearrange spaces

# Disable .DS_Store on network disks
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

# Screen capture
defaults write com.apple.screencapture disable-shadow -bool true

killall Dock
killall Finder
killall SystemUIServer
