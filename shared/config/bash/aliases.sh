#!/bin/sh

alias rm="rm -i"
alias ln="ln -v"
alias cp="cp -iv"
alias mv="mv -iv"
alias mkdir="mkdir -v"
alias chmod="chmod -c"
alias chown="chown -c"

alias ls="ls -F --color=auto"
alias lt="exa -aT --ignore-glob=.git*"
alias ll="exa -alBg --git --time-style=long-iso"
alias lsl="ls -AlF --color=auto --time-style=long-iso"

alias grep="grep --color"
alias less="less --tabs=4 -rF"
alias _date="date \"+%I:%M %p [%A, %d %B %Y (%U)]\""

# arch specific
alias pacrm="sudo pacman -Rs"
alias pacinst="sudo pacman -S"
alias pacclean="sudo pacman -Sc"
alias pacsearch="sudo pacman -Ss"
alias pacupdate="sudo pacman -Syu"
alias pacfix="sudo rm /var/lib/pacman/db.lck"
alias pacfind="sudo pacman -Fy && sudo pacman -Fs"

# directory movement
alias ..="cd .."
alias cd..="cd .."
alias cdw='cd $HOME/workspace'
alias cwd="cdw" # wrapper if misspelling the above alias
alias cds='cd $HOME/workspace/configs/settei'

# change permissions recursive
alias fmode="find . -type f -exec chmod 644 -- {} +"
alias dmode="find . -type d -exec chmod 755 -- {} +"

# screenshot related
if [ $WAYLAND_DISPLAY ]; then
    alias _shot='grim -t png "$(date "+%Y%m%d_%s_screenshot.png")"'
    alias _sshot='grim -t png -g "$(slurp)" "$(date "+%Y%m%d_%s_screenshot.png")"'
else
    alias _shot='maim -o -u -f png "$(date "+%Y%m%d_%s_screenshot.png")"'
    alias _sshot='maim -o -u -f png -s -c 0.4,0.4,0.4,0.5 -b 10000 "$(date "+%Y%m%d_%s_screenshot.png")"'
fi

# nvim related
alias vi="nvim"
alias vim="nvim"
alias nivm="nvim" # wrapper if misspelling nvim

# cmake related
alias cmake="CMAKE_EXPORT_COMPILE_COMMANDS=1 cmake"

# development related
alias make="make -j8"
alias diff="diff --color --tabsize=4"
alias lldb="ASAN_OPTIONS=detect_leaks=0 lldb"
alias sc="shellcheck --exclude=SC1090,SC1094,SC2155,SC2086,SC2032,SC2033 --shell=dash -x"
alias cs="codespell --builtin clear,rare,informal,code,en-GB_to_en-US -S 'dependency/*,*build*/*'"

# other
alias :q="exit"
alias uumount="sudo udiskie-umount --detach"
alias pulsemixer="PULSEMIXER_BAR_STYLE='┌╶┐-└┘■- ──' pulsemixer"
alias sudo="sudo " # this allows to use 'sudo' with aliases
