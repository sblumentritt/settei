#!/bin/sh

# --------------------------------------
# small helper functions
# --------------------------------------
# set local git config to default
glocal() {
    git config user.name "Sebastian Blumentritt"
    git config user.email "blumentritt.sebastian@protonmail.com"

    git config user.signingkey D2CCCB70
    git config commit.gpgSign true
    git config tag.gpgSign true
}

# call 'git pull' for each repo in a max depth of 2 which helps
# to easily synchronize multiple local repos with the remote
gpull() {
    for dir in $(fd --max-depth 2 --type d --hidden); do

        # use subshell which removes the need to `cd -` back
        # as the directory is not changed in the current shell
        (
            cd $dir || exit
            if [ -d ".git/" ]; then
                printf "\n"
                printf "calling 'git pull' for '%s'\n" "$dir"
                printf "===========================================\n"

                git pull
            else
                printf "\n"
                printf "NOTE: '%s' is not a git repository!\n" "$dir"
                printf ":::::::::::::::::::::::::::::::::::::::::::\n"
            fi
        )
    done
}

# reload the history
rhistory() {
    history -c
    history -r
}

# set hardware clock with the help of network time
uclock() {
    local date_utc=$(curl -H "Cache-Control: no-cache" -sD - google.com \
        | grep "^Date:" | cut -d" " -f3-6)
    if [ -n "$date_utc" ]; then
		sudo date -s "${date_utc}Z"
		sudo hwclock -w
	fi
}

# similar to -C option but with offset in decimal format
dhex() {
    command hexdump \
        -e '"%010_Ad\n"' \
        -e '"%010_ad  " 8/1 "%02x " "  " 8/1 "%02x "' \
        -e '"  |" 16/1 "%_p" "|\n"' \
        "$@"
}

# helper to convert between hex and decimal format
nconvert() {
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

# helper to generate a strong password with /dev/urandom
rpw() {
    < /dev/urandom tr -dc ._!\#[]\(\)\{\}A-Z-a-z-0-9 | head -c${1:-30}; printf '\n'
}

# helper to easily build with CMake
cbuild() {
    cmake --build . "$@" --parallel -- -s
}

# helper to for include-what-you-use
iwyu_log() {
    usage="Usage: iwyu_log PATH_TO_BUILD_DIR LOG_FILE_NAME"
    if [ -z "$1" ]; then
        printf "%s\n" "$usage"
    elif [ -z "$2" ]; then
        printf "%s\n" "$usage"
    else
        compile_commands="$1/compile_commands.json"
        if [ -f "$compile_commands" ]; then
            iwyu-tool -j 8 -p "$compile_commands" -o iwyu -- \
                -Xiwyu --no_default_mappings \
                -Xiwyu --mapping_file=$XDG_CONFIG_HOME/iwyu/custom.imp \
                -Xiwyu --cxx17ns \
                -Xiwyu --transitive_includes_only \
                -Xiwyu --quoted_includes_first \
                | sed '/^The full.*/,/---/{//!d}' \
                | sed -E 's/^The full.*//g' \
                | sed 's/^warning:.*//g' \
                | sed -E '/^(.*has correct.*)/d' \
                | sed '/^$/N;/^\n$/D' \
                > $2.iwyu
        else
            printf "%s does not contain a compile_commands.json file!\n" "$1"
        fi
    fi
}

_srecord() {
    local file_name=$(date "+%Y%m%d_%s_screen_record.mp4")
    if [ $WAYLAND_DISPLAY ]; then
        wf-recorder -g "$(slurp)" -f "${file_name}"
    else
        slop_info=$(slop -o -f "%x %y %w %h %g %i" -c 0.4,0.4,0.4,0.5 -b 10000) || return
        read -r X Y W H G ID < <(echo $slop_info)
        ffmpeg -framerate 25 -f x11grab -s "$W"x"$H" -i :0.0+$X,$Y "${file_name}"
    fi
}

# helper to create btrfs snapshots
csnap() {
    local snapshot_date=$(date "+%Y%m%d_%s")

    if [ "$1" = "-r" ]; then
        sudo btrfs subvolume snapshot -r / "/snap/root/root_${snapshot_date}"
    elif [ "$1" = "-h" ]; then
        sudo btrfs subvolume snapshot -r /home "/snap/home/home_${snapshot_date}"
    else
        printf "Usage: csnap [ -r | -h ]\n"
    fi
}

# fuzzy search files and open selected files with $EDITOR
fe() {
    local file=$(fzf -q "$1" -1 -0)
    [ -n "$file" ] && ${EDITOR} "${file}"
}

# kill processes - list only the ones which can be killed from user
fkill() {
    local pid
    pid=$(ps -o pid -o ppid -o stime -o time -o cmd -x --no-headers | fzf -m | awk '{print $1}')

    if [ "x$pid" != "x" ]; then
        printf "%s\n" $pid | xargs kill -${1:-9}
    fi
}

# list local git branches with a removed remote and delete selected ones
fdb() {
    local branches=$(git branch -vv | rg ": gone]" | fzf -m | awk '{print $1}')

    for branch in ${branches}; do
        git branch -D ${branch}
    done
}

# --------------------------------------
# functions to generate exports
# --------------------------------------
__fzf_gen_default_command() {
    local filter="--exclude \"{.git,.clangd,target,build,output,node_modules}\""
    filter="${filter} --exclude \"dependency/*/\""

    export FZF_DEFAULT_COMMAND="fd --type file --hidden --follow --color=never ${filter}"
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
}

__fzf_gen_default_opts() {
    local general="--height 40% --layout=reverse --tabstop=4"

    local base_color="--color fg:8,bg:-1,fg+:-1,bg+:-1,hl:2,hl+:2"
    local extra_color="--color info:6,prompt:8,pointer:2,marker:5,spinner:6,header:4"

    export FZF_DEFAULT_OPTS="${base_color} ${extra_color} ${general}"
}

__exa_gen_colors() {
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
_fzf_compgen_path() {
    fd --hidden --follow --color=never --exclude ".git" . "${1}"
}

# command for listing directory completion
_fzf_compgen_dir() {
    fd --type directory --hidden --follow --color=never --exclude ".git" . "${1}"
}

# --------------------------------------
# commandline prompt
# --------------------------------------
__prompt_command() {
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
