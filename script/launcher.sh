#!/bin/sh

usage()
{
    printf "Usage: %s [ -e | -d ]

where:
    -e for executables
    -d for documents\n" "$(basename "$0")" 1>&2

    exit 1
}

list_executables()
{
    local tmp="/tmp/efl_exe_list"
    [ -f "$tmp" ] && printf "" > "$tmp"

    set -f
    local IFS=:

    for dir in $PATH; do
        set +f
        [ -z "$dir" ] && dir="."
        for file in "$dir"/*; do
            if [ -x "$file" ] && ! [ -d "$file" ]; then
                printf "%s\n" "${file##*/}" >> "$tmp"
            fi
        done
    done

    sort -u < "$tmp"
}

e_flag=0
d_flag=0

# parse commandline arguments with the help of getopts
while getopts ":ed" arg; do
    case "${arg}" in
        e)
            e_flag=1
            ;;
        d)
            d_flag=1
            ;;
        *)
            usage
            ;;
    esac
done

# check that only one flag was set
if [ "${e_flag}" = 0 ] && [ "${d_flag}" = 0 ]; then
    usage
elif [ "${e_flag}" = 1 ] && [ "${d_flag}" = 1 ]; then
    usage
fi

if [ "${e_flag}" = 1 ]; then
    list_executables | fzf | (nohup xargs -I{} sh -c '{} &' >/dev/null 2>&1)
elif [ "${d_flag}" = 1 ]; then
    documents_base_dir="$HOME/documents/pdfs"

    fd --type file --follow --color=never -e pdf . $documents_base_dir | \
        sed -e "s#$documents_base_dir/##g" | \
        fzf | \
        (nohup xargs -I{} sh -c "mupdf $documents_base_dir/{} &" >/dev/null 2>&1)
fi
