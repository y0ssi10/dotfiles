#!/bin/bash
set -e # エラー発生時に終了

# XDG環境変数のデフォルト値を設定
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

  Select:
  [a] run all above
  [d] only download dotfiles
  [l] only link dotfiles
  [s] only setup applications
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
      mkdir -p "$XDG_CONFIG_HOME/$(dirname "$f")"
      die_if_error "create directory $f"
      if [ -L "$XDG_CONFIG_HOME/$f" ]; then
        ln -sfv "$DOT_DIR/$f" "$XDG_CONFIG_HOME/$f"
      else
        ln -sniv "$DOT_DIR/$f" "$XDG_CONFIG_HOME/$f"
      fi
      die_if_error "create symlink for $f"
    done
  else
    die "cannot cd to $DOT_DIR"
  fi
}

echo "$LOGO" "$DIALOG"
# read -r selection
# if [[ "$selection" = *"a"* ]] || [[ "$selection" = *"d"* ]]; then
#   echo "  begin download dotfiles."
#   download_dotfiles
#   echo "  end download dotfiles."
#   echo ""
# fi

# if [[ "$selection" = *"a"* ]] || [[ "$selection" = *"l"* ]]; then
#   echo "  begin link dotfiles."
#   link_dotfiles
#   echo "  end link dotfiles."
#   echo ""
# fi

# if [[ "$selection" = *"a"* ]] || [[ "$selection" = *"s"* ]]; then
#   echo "  begin setup applications."

#   os_install_sh="${DOT_DIR}/etc/${OS}/install.sh"
#   [ -f "$os_install_sh" ] && sh -c "$os_install_sh"
#   echo "  end setup applications."
#   echo ""
# fi

echo "  begin download dotfiles."
download_dotfiles
echo "  end download dotfiles."
echo ""

echo "  begin link dotfiles."
link_dotfiles
echo "  end link dotfiles."
echo ""

echo "  begin setup applications."
os_install_sh="${DOT_DIR}/etc/${OS}/install.sh"
[ -f "$os_install_sh" ] && sh -c "$os_install_sh"
echo "  end setup applications."
echo ""

echo "  finished."
