#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here

if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

# [[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources

[[ -e ~/.Xresources ]] && [[ -n ${DISPLAY} ]] && xrdb -merge ~/.Xresources  >/dev/null 2>&1



# XFT_SETTINGS="
# Xft.antialias:  0
# Xft.autohint:   0
# Xft.dpi:        96
# Xft.hinting:    1
# Xft.hintstyle:  hintmedium
# Xft.lcdfilter:  lcddefault
# Xft.rgba:       none
 #"

# if [ "$SET_XFT_SETTINGS" = "true" ]; then
#   echo "$XFT_SETTINGS" | xrdb -merge > /dev/null 2>&1
# fi


# exec gnome-session
# exec startkde
# exec startxfce4

hsetroot -full /home/akarin/Pictures/flat.png &

# MPD daemon start (if no other user instance exists)
[ ! -s ~/.config/mpd/pid ] && mpd

# export GTK_IM_MODULE='uim'
# export QT_IM_MODULE='uim'
# uim-xim &
# export XMODIFIERS='@im=uim'

# QT_IM_MODULE=uim
# XMODIFIERS=@im=uim
# XMODIFIER=@im=uim
# GTK_IM_MODULE=uim


# export GTK_IM_MODULE=ibus
# export XMODIFIERS=@im=ibus
# export QT_IM_MODULE=ibus
# ibus-daemon -drx

# export GTK_IM_MODULE=fcitx
# export QT_IM_MODULE=fcitx
# export XMODIFIERS="@im=fcitx"



# exec awesome

echo $BSPWM_SOCKET
echo $XDG_CONFIG_HOME

# sxhkd -n &
# exec bspwm

export PANEL_FIFO="/tmp/panel-fifo"
[ -e "$PANEL_FIFO" ] && rm "$PANEL_FIFO"
mkfifo "$PANEL_FIFO"

gsettings-data-convert &
xdg-user-dirs-gtk-update &
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
/usr/lib/gnome-settings-daemon/gnome-settings-daemon &
/usr/lib/gnome-user-share/gnome-user-share &
eval $(gnome-keyring-daemon --start --components=pkcs11,secrets,ssh,gpg)
export GNOME_KEYRING_CONTROL GNOME_KEYRING_PID GPG_AGENT_INFO SSH_AUTH_SOCK
exec cerbere


/usr/bin/start-pulseaudio-x11

# exec pulseaudio -D

exec chown akarin /run/user/1000/pulse
exec chmod 777 /run/user/1000/pulse
