# ~/.bash_logout: executed by bash(1) when login shell exits.

# clear the screen to increase privacy when leaving the console
if [ "$SHLVL" = 1 ]; then
    [ -x /usr/bin/clear_console ] && /usr/bin/clear_console -q
fi
