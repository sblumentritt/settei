#!/bin/sh

export MPD_PORT="7070"
export MPD_HOST="127.0.0.1"

export CC=/usr/bin/clang
export CXX=/usr/bin/clang++

# needed for 'fd' to use terminal colors
export LS_COLORS=

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

if [ -z $WAYLAND_DISPLAY ]; then
    export XSECURELOCK_PASSWORD_PROMPT=time_hex
    export XSECURELOCK_SHOW_HOSTNAME=0
    export XSECURELOCK_SHOW_USERNAME=0
    export XSECURELOCK_SINGLE_AUTH_WINDOW=1
    export XSECURELOCK_SAVER=saver_blank
fi

export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWSTASHSTATE=1
export GIT_PS1_SHOWUPSTREAM=auto
export GIT_PS1_SHOWUNTRACKEDFILES=1

export AUR="https://aur.archlinux.org/"
export GIT="git@github.com:sblumentritt"
export GIT_RO="https://github.com/sblumentritt"

# https://wiki.archlinux.org/index.php/XDG_Base_Directory
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"

# exports to remove pollution of home dir
export TMUX_TMPDIR="$XDG_RUNTIME_DIR"
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
export HISTFILE="$XDG_DATA_HOME/bash/history"
export XINITRC="$XDG_CONFIG_HOME/X11/xinitrc"
export INPUTRC="$XDG_CONFIG_HOME/readline/inputrc"
export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc"

# add rust stable toolchain man pages to search path
if [ -d $RUSTUP_HOME/toolchains/stable-x86_64-unknown-linux-gnu/share/man ]; then
    export MANPATH="$RUSTUP_HOME/toolchains/stable-x86_64-unknown-linux-gnu/share/man:$MANPATH"
fi
