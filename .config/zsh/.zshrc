#!/usr/bin/env zsh

# profile
if [ "$ZSHRC_PROFILE" != "" ]; then
  zmodload zsh/zprof && zprof > /dev/null
fi

## Base Configuration
source-safe() { if [ -f "$1" ]; then source "$1"; fi }
source "$ZRCDIR/base.zsh"

## Options
source "$ZRCDIR/option.zsh"

## Completion
source "$ZRCDIR/completion.zsh"

## Plugin
source "$ZRCDIR/pluginlist.zsh"

## Aliases
source "$ZRCDIR/alias.zsh"

## Post Execution
if ! builtin command -v zinit > /dev/null 2>&1; then
  source "$ZRCDIR/post_load.zsh"
fi

## Execute Script
source-safe "$ZDOTDIR/.zshrc.local"
source-safe "$ZHOMEDIR/.zshrc.local"

# direnv
export EDITOR=vim
eval "$(direnv hook zsh)"

# starship
eval "$(starship init zsh)"
