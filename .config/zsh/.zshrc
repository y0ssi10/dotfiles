### zinit ###
typeset -gAH ZINIT
ZINIT[HOME_DIR]="$XDG_DATA_HOME/zinit"
ZINIT[ZCOMPDUMP_PATH]="$XDG_STATE_HOME/zcompdump"
source "${ZINIT[HOME_DIR]}/bin/zinit.zsh"

### paths ###
typeset -U path PATH
typeset -U fpath

path=(
  "/opt/homebrew/bin"(N-/)
  "$HOME/.local/bin"(N-/)
  "$XDG_CONFIG_HOME/scripts/bin"(N-/)
  "$path[@]"
)

fpath=(
  "$XDG_DATA_HOME/zsh/completions"(N-/)
  "$fpath[@]"
)

### history ###
export HISTFILE="$XDG_STATE_HOME/zsh_history"
export HISTSIZE=12000
export SAVEHIST=10000

### zsh options ###

# Default
setopt NO_BEEP
setopt NO_NOMATCH

# Initialization
setopt NO_GLOBAL_RCS

# Changing Directories
setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_TO_HOME
setopt PUSHD_SILENT
setopt PUSHD_MINUS
setopt CHASE_LINKS

# History
setopt APPEND_HISTORY
setopt EXTENDED_HISTORY
setopt HIST_EXPAND
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_NO_STORE
setopt HIST_REDUCE_BLANKS
setopt HIST_SAVE_NO_DUPS
unsetopt HIST_VERIFY
setopt NO_SHARE_HISTORY

# Completion
setopt AUTO_LIST
setopt AUTO_MENU
setopt AUTO_PARAM_KEYS
setopt AUTO_PARAM_SLASH
setopt AUTO_REMOVE_SLASH
setopt LIST_PACKED
setopt LIST_TYPES
unsetopt MENU_COMPLETE
setopt COMPLETE_IN_WORD
setopt AUTO_NAME_DIRS
setopt ALWAYS_LAST_PROMPT
setopt NO_LIST_AMBIGUOUS

# Expansion and Globbing
setopt MARK_DIRS
setopt EQUALS
setopt EXTENDED_GLOB
setopt GLOB
setopt MAGIC_EQUAL_SUBST
setopt NUMERIC_GLOB_SORT
setopt GLOB_DOTS

# Job Control
setopt AUTO_RESUME
setopt NO_HUP
setopt LONG_LIST_JOBS
setopt NOTIFY

# Input/Output
setopt NO_FLOW_CONTROL
setopt HASH_CMDS
setopt IGNORE_EOF
setopt MAIL_WARNING
setopt PATH_DIRS
setopt PRINT_EIGHT_BIT
setopt INTERACTIVE_COMMENTS
setopt SHORT_LOOPS
setopt RM_STAR_WAIT

# Scripts and Functions
setopt MULTIOS

# Shell Emulation
unsetopt SH_WORD_SPLIT

zshaddhistory() {
  local line="${1%%$'\n'}"
  [[ ! "$line" =~ "^(cd|history|lazygit|la|ll|ls|rm|rmdir|trash)($| )" ]]
}

(( ${+commands[starship]} )) && eval "$(starship init zsh)"

### key bindings ###
clear-screen-and-update-prompt() {
  ALMEL_STATUS=0
  almel::precmd
  zle .clear-screen
}
zle -N clear-screen clear-screen-and-update-prompt

widget::history() {
  local selected="$(history -inr 1 | fzf --exit-0 --query "$LBUFFER" | cut -d' ' -f4- | sed 's/\\n/\n/g')"
  if [ -n "$selected" ]; then
    BUFFER="$selected"
    CURSOR=$#BUFFER
  fi
  zle -R -c # refresh screen
}

widget::ghq::source() {
  local session color icon green="\e[32m" blue="\e[34m" reset="\e[m" checked="\uf631" unchecked="\uf630"
  local sessions=($(tmux list-sessions -F "#S" 2>/dev/null))

  ghq list | sort | while read -r repo; do
    session="${repo//[:. ]/-}"
    color="$blue"
    icon="$unchecked"
    if (( ${+sessions[(r)$session]} )); then
        color="$green"
        icon="$checked"
    fi
    printf "$color$icon %s$reset\n" "$repo"
  done
}
widget::ghq::select() {
  local root="$(ghq root)"
  widget::ghq::source | fzf --exit-0 --preview="fzf-preview-git ${(q)root}/{+2}" --preview-window="right:60%" | cut -d' ' -f2-
}
widget::ghq::dir() {
  local selected="$(widget::ghq::select)"
  if [ -z "$selected" ]; then
      return
  fi

  local repo_dir="$(ghq list --exact --full-path "$selected")"
  BUFFER="cd ${(q)repo_dir}"
  zle accept-line
  zle -R -c # refresh screen
}
widget::ghq::session() {
  local selected="$(widget::ghq::select)"
  if [ -z "$selected" ]; then
      return
  fi

  local repo_dir="$(ghq list --exact --full-path "$selected")"
  local session_name="${selected//[:. ]/-}"

  if [ -z "$TMUX" ]; then
      BUFFER="tmux new-session -A -s ${(q)session_name} -c ${(q)repo_dir}"
      zle accept-line
  elif [ "$(tmux display-message -p "#S")" = "$session_name" ] && [ "$PWD" != "$repo_dir" ]; then
      BUFFER="cd ${(q)repo_dir}"
      zle accept-line
  else
      tmux new-session -d -s "$session_name" -c "$repo_dir" 2>/dev/null
      tmux switch-client -t "$session_name"
  fi
  zle -R -c # refresh screen
}

forward-kill-word() {
  zle vi-forward-word
  zle vi-backward-kill-word
}

zle -N widget::history
zle -N widget::ghq::dir
zle -N widget::ghq::session
zle -N forward-kill-word

bindkey -v
bindkey "^R"        widget::history                 # C-r
bindkey "^G"        widget::ghq::session            # C-g
bindkey "^[g"       widget::ghq::dir                # Alt-g
bindkey "^A"        beginning-of-line               # C-a
bindkey "^E"        end-of-line                     # C-e
bindkey "^K"        kill-line                       # C-k
bindkey "^Q"        push-line-or-edit               # C-q
bindkey "^W"        vi-backward-kill-word           # C-w
bindkey "^X^W"      forward-kill-word               # C-x C-w
bindkey "^?"        backward-delete-char            # backspace
bindkey "^[[3~"     delete-char                     # delete
bindkey "^[[1;3D"   backward-word                   # Alt + arrow-left
bindkey "^[[1;3C"   forward-word                    # Alt + arrow-right
bindkey "^[^?"      vi-backward-kill-word           # Alt + backspace
bindkey "^[[1;33~"  kill-word                       # Alt + delete
bindkey -M vicmd "^A" beginning-of-line             # vi: C-a
bindkey -M vicmd "^E" end-of-line                   # vi: C-e

# Change the cursor between 'Line' and 'Block' shape
function zle-keymap-select zle-line-init zle-line-finish {
  case "${KEYMAP}" in
    main|viins)
      printf '\033[6 q' # line cursor
      ;;
    vicmd)
      printf '\033[2 q' # block cursor
      ;;
  esac
}
zle -N zle-line-init
zle -N zle-line-finish
zle -N zle-keymap-select

### plugins ###
zinit wait lucid null for \
  atinit'source "$ZDOTDIR/.lazy.zshrc"' \
  @'zdharma-continuum/null'
