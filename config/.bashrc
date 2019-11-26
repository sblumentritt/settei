#!/bin/bash

# --------------------------------------
# check if interactively
# --------------------------------------
[[ $- != *i* ]] && return

# --------------------------------------
# enable bash options
# --------------------------------------
shopt -s autocd
shopt -s cmdhist
shopt -s dotglob
shopt -s histappend
shopt -s checkwinsize

# disable history expansion
set +H

# --------------------------------------
# start/attach to tmux
# --------------------------------------
# required here at the top to use it in the next section
alias tmux='tmux -f "$XDG_CONFIG_HOME"/tmux/config'

if [ $WAYLAND_DISPLAY ]; then
    if [ -z "$TMUX" ]; then
        ID="$(tmux ls | grep -vm1 attached | cut -d: -f1)"
        if [ -z "$ID" ]; then
            tmux new-session
        else
            tmux attach-session -t "$ID"
        fi
    fi
fi

# --------------------------------------
# variable exports
# --------------------------------------
export MPD_PORT="7070"
export MPD_HOST="127.0.0.1"

export CC=/usr/bin/clang
export CXX=/usr/bin/clang++

# suppress ugly error which pollute log
export XKB_LOG_LEVEL=critical

# needed for pacdiff
export DIFFPROG="nvim -d"

export PAGER=/usr/bin/less
export MANPAGER="nvim +Man!"

export EDITOR=/usr/bin/nvim
export VISUAL=/usr/bin/nvim

# disable less history feature
export LESSHISTFILE=-

export HISTSIZE=77777
export HISTFILESIZE=77777
export HISTCONTROL=ignoreboth:erasedups

export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWSTASHSTATE=1
export GIT_PS1_SHOWUPSTREAM=auto
export GIT_PS1_SHOWUNTRACKEDFILES=1

export AUR="https://aur.archlinux.org/"
export GIT="git@git.sr.ht:~sblumentritt"
export GIT_RO="https://git.sr.ht/~sblumentritt"

# https://wiki.archlinux.org/index.php/XDG_Base_Directory
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"

# exports to remove pollution of home dir
export TMUX_TMPDIR="$XDG_RUNTIME_DIR"
export GNUPGHOME="$XDG_DATA_HOME/gnupg"
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
export HISTFILE="$XDG_DATA_HOME/bash/history"
export INPUTRC="$XDG_CONFIG_HOME/readline/inputrc"
export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc"

# --------------------------------------
# source files
# --------------------------------------
[ -r /usr/share/bash-completion/bash_completion ] && \
    . /usr/share/bash-completion/bash_completion

[ -r /usr/share/fzf/completion.bash ] && \
    . /usr/share/fzf/completion.bash
[ -r /usr/share/fzf/key-bindings.bash ] && \
    . /usr/share/fzf/key-bindings.bash

[ -r /usr/share/git/completion/git-prompt.sh ] && \
    . /usr/share/git/completion/git-prompt.sh
[ -r /usr/share/git/completion/git-completion.bash ] && \
    . /usr/share/git/completion/git-completion.bash

# --------------------------------------
# aliases
# --------------------------------------
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
alias cdp='cd $HOME/development'
alias cpd="cdp" # wrapper if misspelling the above alias

# change permissions recursive
alias fmode="find . -type f -exec chmod 644 -- {} +"
alias dmode="find . -type d -exec chmod 755 -- {} +"

# grim related
alias _grim='grim -t png "$(date "+%Y%m%d_%H%M%S_grim.png")"'
alias _sgrim='grim -t png -g "$(slurp)" "$(date "+%Y%m%d_%H%M%S_grim.png")"'

# nvim related
alias vi="nvim"
alias vim="nvim"
alias nivm="nvim" # wrapper if misspelling nvim

# cmake related
alias cbuild="cmake --build"
alias cinstall="cmake --install"
alias ccmake="cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=ON"

# development related
alias make="make -j8"
alias diff="diff --color --tabsize=4"
alias lldb="ASAN_OPTIONS=detect_leaks=0 lldb"

# other
alias :q="exit"
alias uumount="sudo udiskie-umount --detach"
alias pulsemixer="PULSEMIXER_BAR_STYLE='┌╶┐-└┘■- ──' pulsemixer"

if [ -f /etc/profile.d/work.sh ]; then
    alias cdw='cd $HOME/development/__work'
fi

# --------------------------------------
# custom functions
# --------------------------------------
# set local git config to default
glocal()
{
    git config user.name "Sebastian Blumentritt"
    git config user.email "blumentritt.sebastian@gmail.com"
}

# reload the history
rhistory()
{
    history -c
    history -r
}

# set hardware clock with the help of network time
uclock()
{
    local date_utc=$(curl -H "Cache-Control: no-cache" -sD - google.com \
        | grep "^Date:" | cut -d" " -f3-6)
    if [ -n "$date_utc" ]; then
		sudo date -s "${date_utc}Z"
		sudo hwclock -w
	fi
}

# similar to -C option but with offset in decimal format
dhex()
{
    command hexdump \
        -e '"%010_Ad\n"' \
        -e '"%010_ad  " 8/1 "%02x " "  " 8/1 "%02x "' \
        -e '"  |" 16/1 "%_p" "|\n"' \
        "$@"
}

# helper to convert between hex and decimal format
nconvert()
{
    if [ "$#" -ne 2 ]; then
        printf "Usage: nconvert [ -x | -d ] NUM\n"
    else
        if [ "$1" = "-x" ]; then
            printf "0x%s -> %d\n" "$2" "0x$2"
        elif [ "$1" = "-d" ]; then
            printf "%d -> 0x%x\n" "$2" "$2"
        fi
    fi
}

# helper to create btrfs snapshots
csnap()
{
    local snapshot_date=$(date "+%Y_%m_%d")

    if [ "$1" = "-r" ]; then
        btrfs subvolume snapshot -r / "/snap/__root_${snapshot_date}"
    elif [ "$1" = "-h" ]; then
        btrfs subvolume snapshot -r /home "/snap/__home_${snapshot_date}"
    else
        printf "Usage: csnap [ -r | -h ]\n"
    fi
}

# fuzzy search files and open selected files with $EDITOR
fe()
{
    local file=$(fzf -q "$1" -1 -0)
    [ -n "$file" ] && ${EDITOR} "${file}"
}

# kill processes - list only the ones which can be killed from user
fkill()
{
    local pid
    pid=$(ps -o pid -o ppid -o stime -o time -o cmd -x --no-headers | fzf -m | awk '{print $1}')

    if [ "x$pid" != "x" ]; then
        printf "%s\n" $pid | xargs kill -${1:-9}
    fi
}

# list local git branches with a removed remote and delete selected ones
fdb()
{
    local branches=$(git branch -vv | rg ": gone]" | fzf -m | awk '{print $1}')

    for branch in ${branches}; do
        git branch -D ${branch}
    done
}

# --------------------------------------
# functions to generate exports
# --------------------------------------
__fzf_gen_default_command()
{
    local filter="--exclude \"{.git,build,output,node_modules}\""
    filter="${filter} --exclude \"third_party/*/\""

    export FZF_DEFAULT_COMMAND="fd --type file --hidden --follow --color=never ${filter}"
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
}

__fzf_gen_default_opts()
{
    local general="--height 40% --layout=reverse --tabstop=4"

    local base_color="--color fg:8,bg:-1,fg+:-1,bg+:-1,hl:2,hl+:2"
    local extra_color="--color info:6,prompt:8,pointer:2,marker:5,spinner:6,header:4"

    export FZF_DEFAULT_OPTS="${base_color} ${extra_color} ${general}"
}

__exa_gen_colors()
{
    local general="reset:xx=38;5;8;1:da=38;5;8:sn=36:sb=36:lp=0"
    local user_group="uu=32:gu=32:ue=0:un=32;1:gn=32;1"
    local permission="ur=0:uw=0:ux=0:gr=0:gw=0:gx=0:tr=0:tw=0:tx=0"
    local git="ga=32;1:gm=33;1:gd=31;1:gv=33;1:gt=33;1"

    export EXA_COLORS="${general}:${user_group}:${permission}:${git}"
}

# call functions by default
__fzf_gen_default_command
__fzf_gen_default_opts
__exa_gen_colors

# --------------------------------------
# fzf configurations
# --------------------------------------
# command for listing path candidates
_fzf_compgen_path()
{
    fd --hidden --follow --color=never --exclude ".git" . "${1}"
}

# command for listing directory completion
_fzf_compgen_dir()
{
    fd --type directory --hidden --follow --color=never --exclude ".git" . "${1}"
}

# --------------------------------------
# commandline prompt
# --------------------------------------
PROMPT_COMMAND=__prompt_command

__prompt_command()
{
    # get last status code
    local exit_status="$?"

    # append last command to history
    history -a

    # define color variables
    local red="\[\033[31m\]"
    local gray="\[\033[90m\]"
    local green="\[\033[32m\]"
    local default="\[\033[0m\]"

    # prompt start
    PS1="${gray}┌─"

    # check of status code is none zero
    if [ "${exit_status}" -ne 0 ]; then
        PS1="${PS1}${red}"
    else
        PS1="${PS1}${green}"
    fi

    # current working directory
    PS1="${PS1}[ \\w ]"

    # git branch with status
    PS1="${PS1}$(__git_ps1 "\[\033[36m\] [%s]")"

    # newline and current user prompt
    PS1="${PS1}\\n${gray}└─\\$ ${default}"
}
