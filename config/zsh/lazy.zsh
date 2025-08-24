### ls-colors ###
export LS_COLORS="di=01;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=01;05;37;41:mi=01;05;37;41:su=37;41:sg=30;43:tw=30;42:ow=34;42:st=37;44:ex=01;32"

### aliases ###
alias cp='cp -i'
alias mv='mv -i'
alias ..='cd ..'

case "$OSTYPE" in
  darwin*)
    path=(
        "/opt/homebrew/opt/coreutils/libexec/gnubin"(N-/)
        "/opt/homebrew/opt/findutils/libexec/gnubin"(N-/)
        "/opt/homebrew/opt/gnu-sed/libexec/gnubin"(N-/)
        "/opt/homebrew/opt/grep/libexec/gnubin"(N-/)
        "/opt/homebrew/opt/make/libexec/gnubin"(N-/)
        "$path[@]"
    )
    alias pp='pbcopy'
    alias p='pbpaste'
  ;;
esac

mkcd() {
  command mkdir -p -- "$@" && builtin cd "${@[-1]:a}"
}

j() {
    local root dir
    root="${$(git rev-parse --show-cdup 2>/dev/null):-.}"
    dir="$(fd --color=always --hidden --type=d . "$root" | fzf --select-1 --query="$*" --preview='fzf-preview-file {}')"
    [[ -n "$dir" ]] && builtin cd "$dir"
}

jj() {
  local root
  root="$(git rev-parse --show-toplevel)" || return 1
  builtin cd "$root"
}

# chmod
alias 644='chmod 644'
alias 755='chmod 755'
alias 777='chmod 777'

### diff ###
diff() {
  command diff "$@" | bat --paging=never --plain --language=diff
  return "${pipestatus[1]}"
}
alias diffall='diff --new-line-format="+%L" --old-line-format="-%L" --unchanged-line-format=" %L"'

### fzf ###
export FZF_DEFAULT_OPTS='--reverse --border --ansi --bind="ctrl-d:print-query,ctrl-p:replace-query"'
export FZF_DEFAULT_COMMAND='fd --hidden --color=always'

### eza ###
if (( ${+commands[eza]} )); then
  alias ls='eza --group-directories-first'
  alias la='eza --group-directories-first -a'
  alias ll='eza --group-directories-first -al --header --color-scale --git --icons --time-style=long-iso'
  alias tree='eza --group-directories-first --tree --icons'
  alias l="clear & ls"
fi

### bat ###
if (( ${+commands[bat]} )); then
  export MANPAGER="sh -c 'col -bx | bat --color=always --language=man --plain'"
  alias cat='bat --paging=never'
fi

### ripgrep ###
export RIPGREP_CONFIG_PATH="$XDG_CONFIG_HOME/ripgrep/config"

### hgrep ###
alias hgrep="hgrep --hidden --glob='!.git/'"

### navi ###
export NAVI_CONFIG="$XDG_CONFIG_HOME/navi/config.yaml"

__navi_search() {
    LBUFFER="$(navi --print --query="$LBUFFER")"
    zle reset-prompt
}
zle -N __navi_search
bindkey '^N' __navi_search

### chpwd-recent-dirs ###
add-zsh-hook chpwd chpwd_recent_dirs
zstyle ':chpwd:*' recent-dirs-file "$XDG_STATE_HOME/chpwd-recent-dirs"

### less ###
export LESSHISTFILE='-'

### completion styles ###
zstyle ':completion:*:default' menu select=1
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

### GPG ###
export GPG_TTY="$(tty)"

### Docker ###
docker() {
  if [[ "$#" -eq 0 ]] || [[ "$1" = "compose" ]] || ! command -v "docker-$1" >/dev/null; then
    command docker "${@:1}"
  else
    "docker-$1" "${@:2}"
  fi
}

docker-clean() {
  command docker ps -aqf status=exited | xargs -r docker rm --
}

docker-cleani() {
  command docker images -qf dangling=true | xargs -r docker rmi --
}

docker-rm() {
  if [[ "$#" -eq 0 ]]; then
    command docker ps -a | fzf --exit-0 --multi --header-lines=1 | awk '{ print $1 }' | xargs -r docker rm --
  else
    command docker rm "$@"
  fi
}

docker-rmi() {
  if [[ "$#" -eq 0 ]]; then
    command docker images | fzf --exit-0 --multi --header-lines=1 | awk '{ print $3 }' | xargs -r docker rmi --
  else
    command docker rmi "$@"
  fi
}

### editor ###
export EDITOR="vi"
(( ${+commands[vim]} )) && EDITOR="vim"
(( ${+commands[nvim]} )) && EDITOR="nvim"

export GIT_EDITOR="$EDITOR"

e() {
    if [ $# -eq 0 ]; then
        local selected="$(fd --hidden --color=always --type=f  | fzf --exit-0 --multi --preview="fzf-preview-file {}" --preview-window="right:60%")"
        [ -n "$selected" ] && "$EDITOR" -- ${(f)selected}
    else
        command "$EDITOR" "$@"
    fi
}

### Suffix alias ###
alias -s {bz2,gz,tar,xz}='tar xvf'
alias -s zip=unzip
alias -s d=rdmd

### aws-cli ###
export AWS_SHARED_CREDENTIALS_FILE="$XDG_CONFIG_HOME/aws/credentials"
export AWS_CONFIG_FILE="$XDG_CONFIG_HOME/aws/config"

### Node.js ###
export NODE_REPL_HISTORY="$XDG_DATA_HOME/node_repl_history"

### npm ###
export NPM_CONFIG_DIR="$XDG_CONFIG_HOME/npm"
export NPM_CONFIG_USERCONFIG="$NPM_CONFIG_DIR/npmrc"

### Python ###
alias python="python3"
alias pip="pip3"
export PYTHONSTARTUP="$XDG_CONFIG_HOME/python/startup.py"

## kubectl ###
alias k='kubectl'

### local ###
if [[ -f "$ZDOTDIR/local.zsh" ]]; then
    source "$ZDOTDIR/local.zsh"
fi

sheldon::load "defer"
