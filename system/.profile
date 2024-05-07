# .profile
# Craig Jennings <c@cjennings.net>

# if connecting to this host via Emacs tramp, set a simple prompt and return
# keep this statement at the top of the file to prevent PS1 from being changed
if [ "$TERM" = "tramp" ] || [ "$TERM" = "dumb" ]; then
    PS1='$ '
fi

# if echo "$(uname)" | grep -q "FreeBSD"; then
#    # make delete do the right thing on freebsd
#    bindkey "\e[3~" delete-char
# fi

##
## ENVIRONMENT VARIABLES
##

export ALTERNATE_EDITOR=""
export BEEP="/usr/share/sounds/freedesktop/stereo/bell.oga"
export BROWSER="$(which google-chrome-stable)"
# export BROWSER="$(which firefox)"
# export BROWSER="$(which librewolf)"
export COLORTERM=truecolor
export EDITOR="$(which emacs)"
export FZF_DEFAULT_COMMAND='rg --files --no-ignore-vcs --hidden'
export GPG_TTY="$(tty)"
export INFOPATH="$HOME/.config/emacs/info:/usr/share/info:/usr/local/share/info"
export LANGUAGE=en_US
export PATH="$PATH:$HOME/.local/bin:/usr/sbin"
[ -d "$HOME/.local/share/gem/ruby/3.0.0/bin" ]; PATH="$PATH:$HOME/.local/share/gem/ruby/3.0.0/bin"
[ -d "$HOME/.cargo/bin" ]; PATH="$PATH:$HOME/.cargo/bin"
export QT_AUTO_SCREEN_SCALE_FACTOR=1
export QT_QPA_PLATFORMTHEME=qt5ct
#export TERM="vt100"
export TERM="st-256color"
export TERMINAL="$(which st)"
export VISUAL="$(which em)"
export XDG_CONFIG_HOME="$HOME/.config/"
export XDG_CURRENT_DESKTOP=dwm
export XDG_SESSION_TYPE=x11
if [ -z "$XDG_RUNTIME_DIR" ]; then
    export XDG_RUNTIME_DIR="$HOME/.local/xdg/runtime"
    if [ ! -d  "$XDG_RUNTIME_DIR" ]; then
        mkdir -p "$XDG_RUNTIME_DIR"
        chmod 0700 "$XDG_RUNTIME_DIR"
    fi
fi

# https://unix.stackexchange.com/questions/230238/x-applications-warn-couldnt-connect-to-accessibility-bus-on-stderr
# emacs/gtk interaction bug workaround
export NO_AT_BRIDGE=1

##
## ALIASES
##

# general convenience
alias backup='sudo rsyncshot backup 1000'
alias beep='paplay $BEEP'
alias cj="cd ~/code/cjennings.net"
alias crm="ticker.sh crm"
alias df='dfc -p /dev/'
alias ducks='du -cksh * | sort -rh | head -n11'
alias feh='feh -ZF'
alias gdbx="gdb --batch --ex r --ex bt --ex q --args"
alias handbrake="ghb"
alias ka="killall"
alias ll="ls -l"
alias mkd="mkdir -pv"
alias mnt="sudo mount -t auto -o rw,umask=0000"
alias myip='curl -4 https://chroot-me.in/ip/ 2> /dev/null || w3m -4 -dump https://chroot-me.in/ip'
alias open="xdg-open"
alias play='mpv --no-video'
alias ptop="sudo powertop"
alias shuffle='mpv --no-video --shuffle '
alias speedtest="speedtest-go"
alias sysinfo='sudo inxi -v 8 -a -xxxA -xxxB -xxxC -xxxD -xxxG -xxxI -xxxm -xxxN -xxxR -xxxS -xxx --usb -d -I -pl -n -s --slots '
alias vim="nvim"
alias weather="curl -s wttr.in"
alias xterm="xterm -ti 340"

# emacs
alias emacswake='for i in `seq 1 500`; do killall -s USR2 emacs; done'  # wake emacs from a freeze

# git
alias gitlog="git log --graph --pretty=format:'%Cred%h%Creset %an: %s - %Creset %C(yellow)%d%Creset %Cgreen(%cr)%Creset' --abbrev-commit --date=relative"
alias gitstatus='git status -sb '
alias gitcom='git commit -m '
alias gitpp='git pull --prune '                    # clean up any orphaned git objects
alias gittagbydate="git for-each-ref --sort=creatordate --format '%(refname) %(creatordate)' refs/tags"

# gcc
alias cc="gcc -Wall -Wstrict-prototypes -Wmissing-prototypes -Wshadow -Wconversion -Wextra -std=c2x -pedantic"

# libreoffice
alias calc="libreoffice --calc"
alias draw="libreoffice --draw"
alias impress="libreoffice --impress"
alias math="libreoffice --math"
alias writer="libreoffice --writer"

# ranger
# when exiting ranger, leave the prompt at the destination
alias cdr='. ranger'
alias r='. ranger'

## sound file conversion
alias aax2flac='AAXtoMP3 -f '
alias aax2mp3='AAXtoMP3 -c -e:mp3 '
alias aax2opus='AAXtoMP3 --opus -t . -c '

# sublime tools
alias stext="/opt/sublime_text/sublime_text"
alias smerge="/usr/bin/smerge"

# tidal-dl
alias tdl="tidal-dl -l"
alias ttdl="tsp tidal-dl -l"

# youtube-dl
alias yt="yt-dlp --ignore-config --no-playlist --add-metadata -i -o '%(channel)s-%(title)s.%(ext)s'"
alias tyt="tsp yt-dlp --ignore-config --no-playlist --add-metadata -i -o '%(channel)s-%(title)s.%(ext)s'"

alias ytp="yt-dlp --ignore-config --yes-playlist --add-metadata -i -o '%(channel)s-%(playlist_title)s-%(playlist_index)s-%(title)s.%(ext)s'"
alias tytp="tsp yt-dlp --ignore-config --yes-playlist --add-metadata -i -o '%(channel)s-%(playlist_title)s-%(playlist_index)s-%(title)s.%(ext)s'"

alias yta="yt-dlp --ignore-config --no-playlist -x -f bestaudio/best -o '%(artist)s-%(title)s.%(ext)s'"
alias tyta="tsp yt-dlp --ignore-config --no-playlist -x -f bestaudio/best -o '%(artist)s-%(title)s.%(ext)s'"

alias ytap="yt-dlp --ignore-config --yes-playlist -x -f bestaudio/best -o '%(playlist_index)s-%(artist)s-%(title)s.%(ext)s'"
alias tytap="tsp yt-dlp --ignore-config --yes-playlist -x -f bestaudio/best -o '%(playlist_index)s-%(artist)s-%(title)s.%(ext)s'"

##
## EMACS
##

# Vterm uses some features (e.g., directory-tracking and prompt-tracking or message passing) that require shell-side configurations.
# This functions enables the shell to send information to vterm via properly escaped sequences.
vterm_printf(){
    if [ -n "$TMUX" ] && ([ "${TERM%%-*}" = "tmux" ] || [ "${TERM%%-*}" = "screen" ] ); then
        # Tell tmux to pass the escape sequences through
        printf "\ePtmux;\e\e]%s\007\e\\" "$1"
    elif [ "${TERM%%-*}" = "screen" ]; then
        # GNU screen (screen, screen-256color, screen-256color-bce)
        printf "\eP\e]%s\007\e\\" "$1"
    else
        printf "\e]%s\e\\" "$1"
    fi
}

##
## FZF
##
export FZF_DEFAULT_OPTS='--height=70%'
export FZF_DEFAULT_COMMAND='rg --files'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"


# previously:
# find ~/books \( -iname \*.epub -o -iname \*.pdf -o -iname \*.djvu \) | fzf | xargs emacs
bk() {
    bkfile=$(find ~/sync/books/ \( -iname "*.pdf" -o -iname "*.epub" -o -iname "*.djvu" \) -print | fzf)
    if [ -n "$bkfile" ]; then
        emacsclient -c -a '' "$bkfile" &
    fi
}

# cd to a directory using fzf
cdd () {
    destdir=$(find "${1:-.}" -path '*/\.*' -prune \
                   -o -type d -print 2> /dev/null | fzf +m) &&
        cd "$destdir"
}

# kill a process with fzf
kp () {
    pid=$(ps -ef | sed 1d | eval "fzf ${FZF_DEFAULT_OPTS} -m --header='[kill:process]'" | awk '{print $2}')

    if [ "x$pid" != "x" ]
    then
        echo "$pid" | xargs kill -${1:-9}
        kp
    fi
}

# cdff - change directory find file
cdff() {

    file=$(fzf +m -q "$1")
    dir=$(dirname "$file")
    cd "$dir" || exit
}

# find-in-file - usage: fif <searchTerm>
fif() {
    if [ ! "$#" -gt 0 ]; then echo "Need a string to search for!"; return 1; fi
    rg --files-with-matches --no-messages "$1" | fzf --preview "highlight -O ansi -l {} 2> /dev/null | rg --colors 'match:bg:yellow' --ignore-case --pretty --context 10 '$1' || rg --ignore-case --pretty --context 10 '$1' {}"
}

# list available packages, show info in preview, and install selection
yinstall() {
	yay -Slq | fzf --multi --preview 'yay -Si {1}' | xargs -ro yay -S --noconfirm
}

# list installed packages, show info in preview, and remove selection
yrm() {
	yay -Qq | fzf --multi --preview 'yay -Qi {1}' | xargs -ro yay -Rns
}


##
## TMUX
##

# selectively start tmux when logging in via ssh
if [[ -z "$TMUX" ]] && [ "$SSH_CONNECTION" != "" ]; then
    export TERM="xterm-mono"
    # if dumb terminal (i.e., tramp), then set a simple prompt, otherwise set monochrome TERM and start tmux
    tmux attach-session -t "$USER" || tmux new-session -s "$USER"
fi


##
## GIT
##

gitsp() {
    git stash && git pull && git stash pop
}

gitck() {
    git checkout "$(git branch --all | fzf| tr -d '[:space:]')"
}

gitdiff() {
    preview="git diff $@ --color=always -- {-1}"
    git diff "$@" --name-only | fzf -m --ansi --preview "$preview"
}


##
## EXTRACT
##

extract () {
    if [ -f "$1" ] ; then
        case "$1" in
            *.tar.bz2)   tar xjf "$1"    ;;
            *.tar.gz)    tar xzf "$1"    ;;
            *.bz2)       bunzip2 "$1"    ;;
            *.rar)       rar x "$1"      ;;
            *.gz)        gunzip "$1"     ;;
            *.tar)       tar xf "$1"     ;;
            *.tbz2)      tar xjf "$1"    ;;
            *.tgz)       tar xzf "$1"    ;;
            *.zip)       unzip "$1"      ;;
            *.Z)         uncompress "$1" ;;
            *)           echo "$1 cannot be extracted via extract()" ;;
        esac
    else
        echo "$1 is not a valid file"
    fi
}

##
## CDL (CD with LF)
## LF, but the prompt is left in the destination directory, rather than $HOME.
##
cdl () {
    tmp="$(mktemp)"
    lfrun -last-dir-path="$tmp" "$@"
    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        rm -f "$tmp"
        if [ -d "$dir" ]; then
            if [ "$dir" != "$(pwd)" ]; then
                cd "$dir"
            fi
        fi
    fi
}

# alias lf=cdl

##
## CLOCK
##

clock() {
    while true; do tput clear; echo ""; date +" %l : %M %p" | figlet -f roman -w 200 ; sleep 1; done
}

##
## TIMER
##

timer() {
    # Ensure we have at least two arguments
    if [ "$#" -lt 2 ]; then
        echo "Pass the time and a notification. Example: timer 1h30m Parking expiring"
        return 1
    fi
    message="${@:2}"
    start_time=$(date +"%H:%M:%S %p")
    printf "\nStarting %s timer at $start_time\n" "$1"
    snore "$1" && paplay "$BEEP" && notify-send "Timer" "$message" && echo ""
}

##
## ALARM
##

alarm() {
    # Ensure we have two or more arguments
    if [ "$#" -lt 2 ]; then
        echo "Pass both the time and a message. Example: alarm 1:45pm Time to eat!"
        return 1
    fi

    # Validate the first argument is a valid time
    ! date -d "$1" >/dev/null 2>&1 && echo "Invalid time: $1" && return 1

    # silently schedule the command using 'at' command
    echo "paplay \$BEEP && notify-send \"Alarm\"  \"$@\"" | at "$1" >> /dev/null 2>&1
    echo "Alarm '${@:2}' is queued for $1." && echo "To see all alarms, issue the command: atq" && echo ""
}

##
## STOPWATCH FUNCTIONS
##

sw_start_time=0
sw_started=0

swreset() {
    sw_start_time=0
    sw_started=0
    echo "Stopwatch reset"
}

swshow() {
    if [ "$sw_started" = 0 ] ; then
        echo "Error: Stopwatch not started" >&2 && return 1
    fi

    current_time=$(date +%s)
    elapsed_time=$((current_time - sw_start_time))

    if (( elapsed_time < 60 )); then
        # Display elapsed time in seconds
        echo "Elapsed time: $elapsed_time seconds"
    elif (( elapsed_time < 3600 )); then
        # Display elapsed time in minutes and seconds
        minutes=$((elapsed_time / 60))
        seconds=$((elapsed_time % 60))
        echo "Elapsed time: $minutes minutes, $seconds seconds"
    else
        # Display elapsed time in hours, minutes, and seconds
        hours=$((elapsed_time / 3600))
        minutes=$(((elapsed_time / 60) % 60))
        seconds=$((elapsed_time % 60))
        echo "Elapsed time: $hours hours, $minutes minutes, and $seconds seconds"
    fi
}

swstop() {
    swshow
    swreset
}

swstart() {
    if [ "$sw_started" = 1 ] ; then
        printf "Stopwatch is already started. Reset? (y/n): "
        read -r answer
        if [ "$answer" = "y" -o "$answer" = "Y" ]; then
            swreset
            # continue on to start the new timer
        elif [ "$answer" = "n" -o "$answer" = "N" ]; then
            echo "Stopwatch not reset."
            swshow
            # return to avoid restarting the timer
            return
        else
            echo "Error: Invalid input. Exiting." >&2 && return 1
        fi
    fi

    sw_started=1
    sw_start_time=$(date +%s)
    printf "Stopwatch started at %s\n\n" "$(date +"%H:%M:%S %p")"
}
