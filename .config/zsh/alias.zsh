# Aliases

## common
alias rm='rm-trash'
alias del='rm -rf'
alias cp='cp -irf'
alias mv='mv -i'
alias ..='cd ..'
alias zcompile_zshrc='zcompile ~/.zshrc'
alias sudo='sudo -H'
alias quit='exit'

# chmod
alias 644='chmod 644'
alias 755='chmod 755'
alias 777='chmod 777'

# grep
alias gre='grep -H -n -I --color=auto'

# vi
alias vi="$EDITOR"
alias sv="sudo $EDITOR"

# replace cat with bat
if builtin command -v bat > /dev/null; then
  unalias -m 'cat'
  alias cat='bat -pp --theme="Nord"'
fi

# replace ls and cat
if builtin command -v exa > /dev/null; then
    unalias -m 'll'
    unalias -m 'l'
    unalias -m 'la'
    unalias -m 'ls'
    alias ls='exa -G  --color auto --icons -a -s type'
    alias ll='exa -l --color always --icons -a -s type'
fi
