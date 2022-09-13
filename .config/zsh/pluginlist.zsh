#!/usr/bin/env zsh

# Setup zinit
if [ -z "$ZPLG_HOME" ]; then
  ZPLG_HOME="$ZDATADIR/zinit"
fi

if ! test -d "$ZPLG_HOME"; then
  mkdir -p "$ZPLG_HOME"
  chmod g-rwX "$ZPLG_HOME"
  git clone --depth 10 https://github.com/zdharma-continuum/zinit.git ${ZPLG_HOME}/bin
fi

typeset -gAH ZPLGM
ZPLGM[HOME_DIR]="${ZPLG_HOME}"
source "$ZPLG_HOME/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Plugin load
## zinit extension
zinit light-mode for \
  @zdharma-continuum/zinit-annex-readurl

## completion
zinit wait'0b' lucid \
  atload"source $ZHOMEDIR/rc/pluginconfig/zsh-autosuggestions_atload.zsh" \
  light-mode for @zsh-users/zsh-autosuggestions

zinit wait'0a' lucid \
  atinit"source $ZHOMEDIR/rc/pluginconfig/zsh-autocomplete_atinit.zsh" \
  atload"source $ZHOMEDIR/rc/pluginconfig/zsh-autocomplete_atload.zsh" \
  light-mode for @marlonrichert/zsh-autocomplete

zinit wait'0b' lucid as"completion" \
  atload"source $ZHOMEDIR/rc/pluginconfig/zsh-completions_atload.zsh" \
  light-mode for @zsh-users/zsh-completions


## prompt
zinit wait'0a' lucid \
  if"(( ${ZSH_VERSION%%.*} > 4.4))" \
  atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" \
  light-mode for @zdharma-continuum/fast-syntax-highlighting

## exa
zinit wait"1" lucid from"gh-r" as"null" for \
     sbin"**/fd"        @sharkdp/fd \
     sbin"**/bat"       @sharkdp/bat \
     sbin"exa* -> exa"  ogham/exa
