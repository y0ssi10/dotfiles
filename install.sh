#!/bin/bash
set -e # エラー発生時に終了

XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"

DOT_DIR="${DOT_DIR:-${HOME}/workspace/github.com/y0ssi10/dotfiles}"
GITHUB_URL="https://github.com/y0ssi10/dotfiles"
LOGO='
       _       _    __ _ _
    __| | ___ | |_ / _(_) | ___  ___
   / _` |/ _ \| __| |_| | |/ _ \/ __|
  | (_| | (_) | |_|  _| | |  __/\__ \
   \__,_|\___/ \__|_| |_|_|\___||___/
'
DIALOG="
  author: @y0ssi10
  repository: $GITHUB_URL

  This script includes:
  (1) download dotfiles
  (2) link dotfiles
  (3) setup applications

  This script also includes for Nix:
  (1') install Xcode, Homebrew and Nix
  (2') bootstrap Nix

  Select:
  [a] run (1) (2) (3) above steps
  [d] only download dotfiles
  [l] only link dotfiles
  [s] only setup applications
  [i] only install Xcode, Homebrew and Nix
  [b] only bootstrap Nix
  [m] only install mise tools
  You can use multiple choose like 'dl'
"

has() {
  type "$1" > /dev/null 2>&1
}

die() {
  echo "$1"
  echo "  terminated."
  exit 1
}

die_if_error() {
  if [ $? -ne 0 ]; then
    die "Error occurred during $1"
  fi
}

OS="unknown"
if [ "$(uname)" = "Darwin" ]; then
  OS="mac"
fi

install_xcode() {
  echo "Try to install Xcode Command Line Tools..."

  if xcode-select -p > /dev/null 2>&1; then
    echo "Xcode Command Line Tools is already installed."
  else
    sudo xcodebuild -license
    xcode-select --install
    echo "Xcode Command Line Tools installed successfully."
  fi

  if [ "$(uname -m)" = "arm64" ]; then
    if ! /usr/bin/pgrep -q oahd; then
      echo "Installing Rosetta..."
      sudo softwareupdate --install-rosetta  --agree-to-license
      echo "Rosetta installed successfully."
    else
      echo "Rosetta is already installed."
    fi
  fi
}

install_nix() {
  if has "nix"; then
    echo "Nix is already installed."
  else
    echo "Running (determinate) nix installer..."
    # use Determinate Nix installer, https://github.com/DeterminateSystems/nix-installer
    curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install --no-confirm	--determinate
    echo "Nix installed successfully."
  fi

  set +o errexit
  set +o nounset
  set +o pipefail
  # load nix commands into the current shell, so that we don't have to open a new one
  # shellcheck disable=SC1091
  . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
  set -o errexit
  set -o nounset
  set -o pipefail

  nix --version
  echo "configured Nix environment successfully."
}

install_homebrew() {
  has "curl" || die "curl is required."
  if has "brew"; then
    echo "Homebrew is already installed."
  else
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo "Homebrew installed successfully."
  fi
  eval "$(/opt/homebrew/bin/brew shellenv)"
  has "brew" || die "brew is required."

  # brew doctor || die "brew doctor raised error."
  echo "  Updating Homebrew..."
  brew update
}

bootstrap_nix() {
  echo "Bootstrapping nix with 'default' configuration..."

  cd "$DOT_DIR" || die "Failed to change directory to $DOT_DIR"

  {
    echo "Backing up /etc/* files..."
    [ ! -f /etc/zshenv ] || sudo mv /etc/zshenv /etc/zshenv.before-nix-darwin
    [ ! -f /etc/zshrc ] || sudo mv /etc/zshrc /etc/zshrc.before-nix-darwin
    [ ! -f /etc/zprofile ] || sudo mv /etc/zprofile /etc/zprofile.before-nix-darwin

    nix run

    # To use flake.nix and default configuration stored in dotfiles repo:
    echo "Bootstrapping nix with 'default' configuration successfully."
  } || {
    echo "Bootstrapping nix with 'default' configuration failed, restoring /etc/* files..."
    [ -f /etc/zshenv.before-nix-darwin ] && sudo mv /etc/zshenv.before-nix-darwin /etc/zshenv
    [ -f /etc/zshrc.before-nix-darwin ] && sudo mv /etc/zshrc.before-nix-darwin /etc/zshrc
    [ -f /etc/zprofile.before-nix-darwin ] && sudo mv /etc/zprofile.before-nix-darwin /etc/zprofile
    echo "Bootstrapping nix with 'default' configuration failed, restoring /etc/* files successfully."
  }
}

install_mise_tools() {
  has "mise" || die "mise is required."
  mise install
}

download_dotfiles() {
  if [ -d "$DOT_DIR" ]; then
    echo "$DOT_DIR is already exist"
  else
    if has "git"; then
      git clone --recursive "$GITHUB_URL" "$DOT_DIR"
      die_if_error "git_clone"
    elif has "curl"; then
      local tarball_url="${GITHUB_URL}/archive/HEAD.tar.gz"
      curl -L "$tarball_url" | tar xv

      die_if_error "download and extract"
      mv -f dotfiles-master "$DOT_DIR"
      die_if_error "move directory"
    else
      die "cannot download dotfiles."
    fi
  fi
}

link_dotfiles() {
  mkdir -p \
    "$XDG_CONFIG_HOME" \
    "$XDG_STATE_HOME" \
    "$XDG_DATA_HOME/vim"

  if cd "$DOT_DIR"; then
    for f in $(find . -not -path '*.git*' -not -path '*node_modules*' -not -path '*.DS_Store' -path '*/.*' -type f -print | cut -b3-)
    do
      mkdir -p "$HOME/$(dirname "$f")"
      die_if_error "create directory $f"
      if [ -L "$HOME/$f" ]; then
        ln -sfv "$DOT_DIR/$f" "$HOME/$f"
      else
        ln -sniv "$DOT_DIR/$f" "$HOME/$f"
      fi
      die_if_error "create symlink for $f"
    done
  else
    die "cannot cd to $DOT_DIR"
  fi
}

echo "$LOGO" "$DIALOG"

if [ -n "$1" ]; then
  selection="$1"
else
  read -r selection
fi

if [[ "$selection" = *"a"* ]] || [[ "$selection" = *"d"* ]]; then
  echo "  begin download dotfiles."
  download_dotfiles
  echo "  end download dotfiles."
  echo ""
fi

if [[ "$selection" = *"a"* ]] || [[ "$selection" = *"l"* ]]; then
  echo "  begin link dotfiles."
  link_dotfiles
  echo "  end link dotfiles."
  echo ""
fi

if [[ "$selection" = *"a"* ]] || [[ "$selection" = *"s"* ]]; then
  echo "  begin setup applications."

  os_install_sh="${DOT_DIR}/etc/${OS}/install.sh"
  [ -f "$os_install_sh" ] && sh -c "$os_install_sh"
  echo "  end setup applications."
  echo ""
fi

if [[ "$selection" = *"i"* ]]; then
  echo "  begin install XCode Command Line Tools..."
  install_xcode
  echo "  end install XCode Command Line Tools."
  echo ""
  echo "  begin install Homebrew..."
  install_homebrew
  echo "  end install Homebrew."
  echo ""
  echo "  begin install Nix..."
  install_nix
  echo "  end install Nix."
  echo ""
fi

if [[ "$selection" = *"b"* ]]; then
  echo "  begin bootstrap Nix..."
  bootstrap_nix
  echo "  end bootstrap Nix."
  echo ""
fi

if [[ "$selection" = *"m"* ]]; then
  echo "  begin install mise tools..."
  install_mise_tools
  echo "  end install mise tools."
  echo ""
fi

echo "  finished."
