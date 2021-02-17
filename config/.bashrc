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
# source all file from ~/.config/bash/
# --------------------------------------
for file in "$HOME/.config/bash/"*; do
    . "${file}"
done

# --------------------------------------
# source other useful files
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

[ -r $RUSTUP_HOME/toolchains/stable-x86_64-unknown-linux-gnu/etc/bash_completion.d/cargo ] && \
    . $RUSTUP_HOME/toolchains/stable-x86_64-unknown-linux-gnu/etc/bash_completion.d/cargo

# set prompt via a function
PROMPT_COMMAND=__prompt_command
