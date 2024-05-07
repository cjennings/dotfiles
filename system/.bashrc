#!/bin/bash
# cjennings .bashrc

# tells shellcheck not to follow references to other files
# shellcheck source=/dev/null

# If not running interactively, don't do anything
case $- in
	*i*) ;;
	  *) return;;
esac

# env variables, aliases, and functions that are not bash specific
source "$HOME"/.profile

# don't put duplicate lines or lines starting with space in the history.
HISTCONTROL=ignoreboth

# infinite history
HISTSIZE=HISTFILESIZE=

# append and reload the history after each command
PROMPT_COMMAND="history -a; history -n"

# ignore the following commands from the history
HISTIGNORE="ls:ll:cd:pwd:bg:fg:history"

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=100000
HISTFILESIZE=10000000

# append to the history file, don't overwrite it
shopt -s histappend

# cd to directory by typing its name
shopt -s autocd

# check window size after each command + update LINES and COLUMNS values.
shopt -s checkwinsize

# enable programmable completion features
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
	. /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
	. /etc/bash_completion
  fi
fi
if [ -f /etc/bash_completion ]; then
 . /etc/bash_completion
fi

export PS1="[\d, \t] \u@\H:\w \n$ "

source "$HOME"/.profile

[ -f "$HOME"/.fzf.bash ] && source "$HOME"/.fzf.bash
