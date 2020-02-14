#!/bin/sh

usage() {
    printf "Usage: %s [ -s | -m ] -w <1-4>

where:
    -s switch to workspace
    -m move focused container to workspace
    -w workspace id for which the action should happen\n" "$(basename "$0")" 1>&2

    exit 1
}

s_flag=0
m_flag=0

# parse commandline arguments with the help of getopts
while getopts ":smw:" arg; do
    case "${arg}" in
        s)
            s_flag=1
            ;;
        m)
            m_flag=1
            ;;
        w)
            workspace_id="${OPTARG}"
            ;;
        *)
            usage
            ;;
    esac
done

# check that the mandatory flag was set and that only one option flag was set
if [ -z "${workspace_id}" ]; then
    usage
elif [ "${s_flag}" = 0 ] && [ "${m_flag}" = 0 ]; then
    usage
elif [ "${s_flag}" = 1 ] && [ "${m_flag}" = 1 ]; then
    usage
fi

monitor_num=$(swaymsg -t get_outputs | \
    jq -r '.[] | select(.focused) | .current_workspace' | \
    cut -f 1 -d ':')

case "${workspace_id}" in
    *1*)
        message_base="workspace '$monitor_num: 一 '"
        ;;
    *2*)
        message_base="workspace '$monitor_num: 二 '"
        ;;
    *3*)
        message_base="workspace '$monitor_num: 三 '"
        ;;
    *4*)
        message_base="workspace '$monitor_num: 四 '"
        ;;
    *)
        usage
        ;;
esac

if [ $s_flag = 1 ]; then
    swaymsg "${message_base}"
elif [ $m_flag = 1 ]; then
    swaymsg "move container to ${message_base}"
fi
