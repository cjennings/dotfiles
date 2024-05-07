# source appropriate dotfiles if they exist
[ -f ~/.profile ] && source ~/.profile
[ -f ~/.secrets ] && source ~/.secrets
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[ -f ~/.zsh/fzf-tab.zsh ] && source ~/.zsh/fzf-tab.zsh


# GENERAL #####################
setopt PROMPT_SUBST             # allow env variables in prompt
setopt AUTO_REMOVE_SLASH        # self explicit
setopt CHASE_LINKS              # resolve symlinks
setopt CORRECT                  # try to correct spelling of commands
setopt EXTENDED_GLOB            # activate complex pattern globbing
setopt GLOB_DOTS                # include dotfiles in globbing
setopt PRINT_EXIT_VALUE         # print return value if non-zero
setopt CLOBBER                  # don't need to use >| to truncate existing files
setopt interactivecomments      # allow comments in command line like bash
unsetopt BEEP                   # no bell on error
unsetopt BG_NICE                # no lower prio for background jobs
unsetopt HIST_BEEP              # no bell on error in history
unsetopt HUP                    # no hup signal at shell exit
unsetopt IGNORE_EOF             # do not exit on end-of-file
unsetopt LIST_BEEP              # no bell on ambiguous completion
unsetopt RM_STAR_SILENT         # ask for confirmation for `rm *' or `rm path/*'
autoload -U colors zsh-mime-setup select-word-style
colors          # colors
zsh-mime-setup  # run everything as if it's an executable


# HISTORY #####################
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000000
SAVEHIST=$HISTSIZE
setopt BANG_HIST                 # Treat the '!' character specially during expansion.
setopt EXTENDED_HISTORY          # Write the history file in the ":start:elapsed;command" format.
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first when trimming history.
setopt HIST_IGNORE_DUPS          # Don't record an entry that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete old recorded entry if new entry is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a line previously found.
setopt HIST_IGNORE_SPACE         # Don't record an entry starting with a space.
setopt HIST_SAVE_NO_DUPS         # Don't write duplicate entries in the history file.
setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks before recording entry.
setopt HIST_VERIFY               # Don't execute immediately upon history expansion.
setopt HIST_BEEP                 # Beep when accessing nonexistent history.

# KEYBOARD ##################
# create a zkbd compatible hash;
# to add other keys to this hash, see: man 5 terminfo
typeset -g -A key

key[Home]="${terminfo[khome]}"
key[End]="${terminfo[kend]}"
key[Insert]="${terminfo[kich1]}"
key[Backspace]="${terminfo[kbs]}"
key[Delete]="${terminfo[kdch1]}"
key[Up]="${terminfo[kcuu1]}"
key[Down]="${terminfo[kcud1]}"
key[Left]="${terminfo[kcub1]}"
key[Right]="${terminfo[kcuf1]}"
key[PageUp]="${terminfo[kpp]}"
key[PageDown]="${terminfo[knp]}"
key[Shift-Tab]="${terminfo[kcbt]}"

# setup key accordingly
[[ -n "${key[Home]}"      ]] && bindkey -- "${key[Home]}"       beginning-of-line
[[ -n "${key[End]}"       ]] && bindkey -- "${key[End]}"        end-of-line
[[ -n "${key[Insert]}"    ]] && bindkey -- "${key[Insert]}"     overwrite-mode
[[ -n "${key[Backspace]}" ]] && bindkey -- "${key[Backspace]}"  backward-delete-char
[[ -n "${key[Delete]}"    ]] && bindkey -- "${key[Delete]}"     delete-char
[[ -n "${key[Up]}"        ]] && bindkey -- "${key[Up]}"         up-line-or-history
[[ -n "${key[Down]}"      ]] && bindkey -- "${key[Down]}"       down-line-or-history
[[ -n "${key[Left]}"      ]] && bindkey -- "${key[Left]}"       backward-char
[[ -n "${key[Right]}"     ]] && bindkey -- "${key[Right]}"      forward-char
[[ -n "${key[PageUp]}"    ]] && bindkey -- "${key[PageUp]}"     beginning-of-buffer-or-history
[[ -n "${key[PageDown]}"  ]] && bindkey -- "${key[PageDown]}"   end-of-buffer-or-history
[[ -n "${key[Shift-Tab]}" ]] && bindkey -- "${key[Shift-Tab]}"  reverse-menu-complete

# cjennings additions #################
bindkey -e				# emacs keybindings
bindkey '\e[1;5C' forward-word          # C-Right
bindkey '\e[1;5D' backward-word         # C-Left
bindkey -s "\e[24~" ""                  # stop F12 from spitting tildes

# Finally, make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.
if (( ${+terminfo[smkx]} && ${+terminfo[rmkx]} )); then
	autoload -Uz add-zle-hook-widget
	function zle_application_mode_start { echoti smkx }
	function zle_application_mode_stop { echoti rmkx }
	add-zle-hook-widget -Uz zle-line-init zle_application_mode_start
	add-zle-hook-widget -Uz zle-line-finish zle_application_mode_stop
fi

# COMPLETION ##################
autoload -U compinit
compinit
zmodload -i zsh/complist        
setopt AUTO_LIST          # list options on ambiguous completion 
setopt AUTO_MENU          # show menu on second request for completion
setopt ALWAYS_TO_END            # when completing from middle of a word, move cursor to end of word    
setopt COMPLETE_IN_WORD         # allow completion from within a word/phrase
setopt COMPLETEALIASES          # complete alisases
setopt CORRECT                  # spelling correction for commands
setopt HASH_LIST_ALL            # hash everything before completion
setopt LIST_AMBIGUOUS           # complete as much of a completion until it gets

zstyle ':completion::complete:*' use-cache on               # completion caching, use rehash to clear
zstyle ':completion:*' cache-path ~/.zsh/cache              # cache path
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'   # ignore case
zstyle ':completion:*' menu select=2                        # menu if nb items > 2
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}       # colorz !
zstyle ':completion:*::::' completer _expand _complete _ignored _approximate # list of completers to use

# sections completion 
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format $'\e[00;34m%d'
zstyle ':completion:*:messages' format $'\e[00;31m%d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*:manuals' separate-sections true

zstyle ':completion:*:processes' command 'ps -au$USER'
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*' force-list always
zstyle ':completion:*:*:kill:*:processes' list-colors "=(#b) #([0-9]#)*=29=34"
zstyle ':completion:*:*:killall:*' menu yes select
zstyle ':completion:*:killall:*' force-list always
users=(cjennings root)           # because I don't care about others
zstyle ':completion:*' users $users

#generic completion with --help
compdef _gnu_generic gcc
compdef _gnu_generic gdb

# DIRECTORY NAVIGATION ########
setopt AUTO_CD            # if typing directory name, auto cd there
setopt AUTO_PUSHD         # push old directories to stack (for use with popd)
setopt PUSHD_IGNORE_DUPS  # don’t push multiple copies of same directory onto stack
setopt PUSHD_SILENT       # don't print directory stack after pushd/popd
setopt PUSHD_TO_HOME      # pushd == `pushd $HOME`

# VERSION CONTROL 
autoload -Uz vcs_info     # Load version control information
precmd() { vcs_info }     

# Styling the version control info
zstyle ':vcs_info:*' enable git cvs svn                # enable only the repo systems I use
zstyle ':vcs_info:*' check-for-changes false           # don't check for changes in local repo
zstyle ':vcs_info:git*' formats "on %b"               # format the vcs_info_msg_0_ variable

# HISTORY ####################
export HISTFILE=~/.zsh_history
export HISTFILESIZE=1000000000
export HISTSIZE=1000000000
setopt INC_APPEND_HISTORY
export HISTTIMEFORMAT="[%F %T] "
setopt EXTENDED_HISTORY
setopt HIST_IGNORE_ALL_DUPS

# PROMPT #####################
NL=$'\n'
WHO='%n'

PROMPT='[%D %*] $WHO $HOST:${PWD/#$HOME/~} ${vcs_info_msg_0_}$NL%# '

# PYTHON POETRY  #############
fpath+=~/.zfunc
autoload -Uz compinit && compinit
