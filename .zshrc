# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/akarin/.zshrc'




#------------------------------
# Comp stuff
#------------------------------
zmodload zsh/complist
autoload -Uz compinit
compinit
zstyle :compinstall filename '${HOME}/.zshrc'

#- buggy
zstyle ':completion:*:descriptions' format '%U%B%d%b%u'
zstyle ':completion:*:warnings' format '%BSorry, no matches for: %d%b'
#-/buggy

zstyle ':completion:*:pacman:*' force-list always
zstyle ':completion:*:*:pacman:*' menu yes select

zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*' force-list always

zstyle ':completion:*:*:killall:*' menu yes select
zstyle ':completion:*:killall:*' force-list always

#- complete pacman-color the same as pacman
compdef _pacman pacman-color=pacman




#------------------------------
# Window title
#------------------------------
case $TERM in
  termite|*xterm*|rxvt|rxvt-unicode|rxvt-256color|rxvt-unicode-256color|(dt|k|E)term)
    precmd () {
      print -Pn "\e]0;urxvt\a"
    }
    preexec () { print -Pn "\e]0;% urxvt ~ $1\a" }
    ;;
  screen|screen-256color)
    precmd () {
      print -Pn "\e]83;title \"$1\"\a"
      print -Pn "\e]0;$TERM - (%L) urxvt\a"
    }
    preexec () {
      print -Pn "\e]83;title \"$1\"\a"
      print -Pn "\e]0;$TERM - (%L) urxvt ~ $1\a"
    }
    ;;
esac




setopt HIST_IGNORE_DUPS








#----------------------------------------------------------------

export PATH=$PATH:/home/akarin/.config/bspwm/panel

[[ $- != *i* ]] && return

# [[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources

alias nightly='dbus-launch firefox-nightly'
alias burn='echo growisofs -dvd-compat -Z /dev/sr0='
alias transcode='ffmpeg -i output.mkv -crf 4 -b:v 5M -preset veryslow'
alias record='ffmpeg -r 15 -s 1440x900 -f x11grab -i $DISPLAY+nomouse -crf 0 output.mkv'
alias transmission='transmission-remote-cli'
alias torrent='transmission-daemon -g /home/akarin/.config/transmission --log-error && transmission-remote-cli'

alias colours='/usr/local/bin/colours.sh'
alias colournames='/usr/local/bin/colournames.sh'
alias colourblocks='/usr/local/bin/colourblocks.sh'
alias colourdots='/usr/local/bin/colourdots.sh'
alias pipes='/usr/local/bin/pipes.sh'
alias pipesx='/usr/local/bin/pipesX.sh'
#-- alias matrix='/home/akarin/.matrix.sh'
alias matrix='cmatrix'

alias sleep='pm-suspend'
alias hibernate='sudo pm-hibernate'
alias vscrot='byzanz-record'
alias ampv='cp ~/.ampv.conf ~/.config/ampv.conf && ampv'

alias fan2000='sudo echo 2000 > /sys/devices/platform/applesmc.768/fan1_min'
alias fan4000='sudo echo 4000 > /sys/devices/platform/applesmc.768/fan1_min'
alias fan6000='sudo echo 6000 > /sys/devices/platform/applesmc.768/fan1_min'
alias fan8000='sudo echo 8000 > /sys/devices/platform/applesmc.768/fan1_min'

alias ls='ls --color=auto'
PS1='» '

PATH="`ruby -e 'puts Gem.user_dir'`/bin:$PATH"

export GEM_HOME=$(ruby -e 'puts Gem.user_dir')

export PATH="home/akarin/.gem/ruby/2.1.0/bin:$PATH"

# export GTK_IM_MODULE=ibus
# export XMODIFIERS=@im=ibus
# export QT_IM_MODULE=ibus

# export GTK_IM_MODULE='uim'
# export QT_IM_MODULE='uim'
# uim-xim &
# export XMODIFIERS='@im=uim'

# ibus-daemon -drx
