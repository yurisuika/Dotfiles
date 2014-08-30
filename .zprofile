
# If not running interactively, don't do anything
[[ -f ~/.zshrc ]] && . ~/.zshrc
[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx

export PANEL_FIFO="/tmp/panel-fifo"
[ -e "$PANEL_FIFO" ] && rm "$PANEL_FIFO"
mkfifo "$PANEL_FIFO"
