### locale ###
export LC_ALL="${LC_ALL:-en_US.UTF-8}"
export LANG="${LANG:-en_US.UTF-8}"

### XDG ###
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CACHE_HOME="$HOME/.cache"

### zsh ###
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

### Go ###
export GOPATH="$XDG_DATA_HOME/go"
export GO111MODULE="on"

### Rust ###
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
export CARGO_HOME="$XDG_DATA_HOME/cargo"

### sheldon ###
export SHELDON_CONFIG_DIR="$ZDOTDIR"

### mise ###
export MISE_DATA_DIR="$XDG_DATA_HOME/mise"
export MISE_STATE_DIR="$XDG_STATE_HOME/mise"
export MISE_CONFIG_DIR="$XDG_CONFIG_HOME/mise"
export MISE_CACHE_DIR="$XDG_CACHE_HOME/mise"

export GNUPGHOME="$XDG_DATA_HOME/gnupg"
