#############
# paths
#############

typeset -gU PATH path
typeset -gU FPATH fpath

path=(
  "$MISE_DATA_DIR/shims"(N-/)
  "/opt/homebrew/bin"(N-/) # for Apple Silicon
  "/opt/homebrew/sbin"(N-/) # for Apple Silicon
  "/usr/bin"(N-/)
  "/usr/sbin"(N-/)
  "/bin"(N-/)
  "/sbin"(N-/)
  "/usr/local/bin"(N-/)
  "/usr/local/sbin"(N-/)
  "$HOME/.local/bin"(N-/)
  "$CARGO_HOME/bin"(N-/)
  "$GOPATH/bin"(N-/)
  "$XDG_CONFIG_HOME/scripts/bin"(N-/)
  "$XDG_DATA_HOME/npm/bin"(N-/)
  "$path[@]"
)

fpath=(
  "$XDG_DATA_HOME/zsh/completions"(N-/)
  "/opt/homebrew/share/zsh/site-functions" # for Apple Silicon
  "$fpath[@]"
)

#############
# history
#############
export HISTFILE="$XDG_STATE_HOME/zsh_history"
export HISTSIZE=12000
export SAVEHIST=10000

#############
# zsh options
#############

# Default
setopt NO_BEEP # Disable terminal beep sound
setopt NO_NOMATCH # Prevent errors for unmatched globs

# Initialization
setopt NO_GLOBAL_RCS # Do not source global zshrc files

# Changing Directories
setopt AUTO_CD # Change to a directory just by typing its name
setopt AUTO_PUSHD # Automatically push the old directory onto the stack on cd
setopt PUSHD_IGNORE_DUPS # Do not push multiple copies of the same directory onto the stack
setopt PUSHD_TO_HOME # Push to home directory when no argument is given
setopt PUSHD_SILENT # Do not print directory stack after pushd or popd
setopt PUSHD_MINUS # Swap the meaning of 'pushd +N' and 'pushd -N'
setopt CHASE_LINKS # Resolve symbolic links to their target directory

# History
setopt APPEND_HISTORY # Append history to the history file (don't overwrite)
setopt EXTENDED_HISTORY # Save timestamp of command in history
setopt HIST_EXPAND # Enable history expansion
setopt HIST_IGNORE_ALL_DUPS # Remove all previous occurrences of a command before saving it
setopt HIST_IGNORE_DUPS # Do not record an entry that was just recorded again
setopt HIST_IGNORE_SPACE # Do not record commands that start with a space
setopt HIST_NO_STORE # Do not store history commands that begin with a space
setopt HIST_REDUCE_BLANKS # Remove superfluous blanks from each command line being added to the history list
setopt HIST_SAVE_NO_DUPS # Do not write duplicate entries in the history file
setopt NO_SHARE_HISTORY # Do not share history between all sessions
unsetopt HIST_VERIFY # Do not show the history line before executing

# Completion
setopt AUTO_LIST # Automatically list choices on ambiguous completion
setopt AUTO_MENU # Use menu completion
setopt AUTO_PARAM_KEYS # Complete parameter names and values
setopt AUTO_PARAM_SLASH # If a parameter is a directory, add a trailing slash
setopt AUTO_REMOVE_SLASH # Remove trailing slash when completing non-directories
setopt LIST_PACKED # Display completion list in columns
setopt LIST_TYPES # List file types in completion
setopt COMPLETE_IN_WORD # Complete from within a word
setopt AUTO_NAME_DIRS # Automatically create named directories for paths
setopt ALWAYS_LAST_PROMPT # Always display the prompt as the last thing in the terminal
setopt NO_LIST_AMBIGUOUS # Do not list ambiguous completions
unsetopt MENU_COMPLETE # Do not use menu completion

# Expansion and Globbing
setopt MARK_DIRS # Mark directories with a trailing slash
setopt EQUALS # Enable the use of '=' for path expansion
setopt EXTENDED_GLOB # Enable extended globbing syntax
setopt GLOB # Enable filename globbing
setopt MAGIC_EQUAL_SUBST # Enable magic '=' substitution
setopt NUMERIC_GLOB_SORT # Sort filenames numerically when globbing
setopt GLOB_DOTS # Include dotfiles in globbing

# Job Control
setopt AUTO_RESUME # Automatically resume stopped jobs
setopt NO_HUP # Do not send HUP signal to jobs on shell exit
setopt LONG_LIST_JOBS # List jobs in long format
setopt NOTIFY # Notify when jobs change status

# Input/Output
setopt NO_FLOW_CONTROL # Disable flow control (^S/^Q)
setopt HASH_CMDS # Remember the location of commands
setopt IGNORE_EOF # Do not exit on EOF (Ctrl-D)
setopt MAIL_WARNING # Notify when mail is received
setopt PATH_DIRS # Search each directory in $PATH for commands
setopt PRINT_EIGHT_BIT # Allow printing of 8-bit characters
setopt INTERACTIVE_COMMENTS # Allow comments in interactive shell
setopt SHORT_LOOPS # Use short loops for certain constructs
setopt RM_STAR_WAIT # Wait for confirmation when using 'rm *'

# Scripts and Functions
setopt MULTIOS # Allow multiple redirections of output

# Shell Emulation
unsetopt SH_WORD_SPLIT # Do not split words on whitespace in unquoted parameter expansions

# starship
(( ${+commands[starship]} )) && eval "$(starship init zsh)"

### source ###
source() {
  local input="$1"
  local cache="$input.zwc"
  if [[ ! -f "$cache" || "$input" -nt "$cache" ]]; then
      zcompile "$input"
  fi
  \builtin source "$@"
}

#############
# zsh hooks
#############
zshaddhistory() {
  local line="${1%%$'\n'}"
  [[ ! "$line" =~ "^(cd|history|lazygit|la|ll|ls|rm|rmdir|trash)($| )" ]]
}

chpwd() {
    printf "\e[34m%s\e[m:\n" "${PWD/$HOME/~}"
    if (( ${+commands[eza]} )); then
        eza --group-directories-first --icons -a
    else
        ls -a
    fi
}

#############
# key bindings
#############
widget::history() {
  local selected="$(history -inr 1 | fzf --exit-0 --query "$LBUFFER" | cut -d' ' -f4- | sed 's/\\n/\n/g')"
  if [ -n "$selected" ]; then
    BUFFER="$selected"
    CURSOR=$#BUFFER
  fi
  zle -R -c # refresh screen
}

widget::ghq::source() {
    readonly local green="\e[32m"
    readonly local blue="\e[34m"
    readonly local reset="\e[m"
    readonly checked="󰄲"
    readonly unchecked="󰄱"
    local sessions=($(tmux list-sessions -F "#S" 2>/dev/null))
    local session
    local color
    local icon

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
    if [[ -z "$selected" ]]; then
        return
    fi

    local repo_dir="$(ghq list --exact --full-path "$selected")"
    BUFFER="cd ${(q)repo_dir}"
    zle accept-line
    zle -R -c # refresh screen
}

widget::ghq::session() {
    local selected="$(widget::ghq::select)"
    if [[ -z "$selected" ]]; then
        return
    fi

    local repo_dir="$(ghq list --exact --full-path "$selected")"
    local session_name="${selected//[:. ]/-}"

    if [[ -z "$TMUX" ]]; then
        BUFFER="tmux new-session -A -s ${(q)session_name} -c ${(q)repo_dir}"
        zle accept-line
    elif [[ "$(tmux display-message -p "#S")" != "$session_name" ]]; then
        tmux new-session -d -s "$session_name" -c "$repo_dir" 2>/dev/null
        tmux switch-client -t "$session_name"
    else
        BUFFER="cd ${(q)repo_dir}"
        zle accept-line
    fi
    zle -R -c # refresh screen
}

zle -N widget::history
zle -N widget::ghq::dir
zle -N widget::ghq::session

bindkey -v
bindkey "^R"        widget::history                 # C-r
bindkey "^G"        widget::ghq::session            # C-g
bindkey "^[g"       widget::ghq::dir                # Alt-g
bindkey "^A"        beginning-of-line               # C-a
bindkey "^E"        end-of-line                     # C-e
bindkey "^K"        kill-line                       # C-k
bindkey "^Q"        push-line-or-edit               # C-q
bindkey "^W"        vi-backward-kill-word           # C-w
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
sheldon::load() {
  local profile="$1"
  local plugins_file="$SHELDON_CONFIG_DIR/plugins.toml"
  local cache_file="$XDG_CACHE_HOME/sheldon/$profile.zsh"
  if [[ ! -f "$cache_file" || "$plugins_file" -nt "$cache_file" ]]; then
    mkdir -p "$XDG_CACHE_HOME/sheldon"
    sheldon --profile="$profile" source >"$cache_file"
    zcompile "$cache_file"
  fi
  \builtin source "$cache_file"
}

sheldon::update() {
    sheldon --profile="sync" lock --update
    sheldon --profile="defer" lock --update
}

sheldon::load "sync"
