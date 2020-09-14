#!/bin/sh

music_info() {
    local symbol=""
    local song=""

    # only check mpd status on a system where mpd should run
    if [ -f /etc/profile.d/work.sh ]; then
        symbol="[?]"
    else
        local playing=$(mpc status | sed -n 2p | cut -c1-9)

        if [ "${playing}" = "[playing]" ]; then
            symbol="[>] "
            song="$(mpc current -f "%artist% - %title%")"
        elif [ "${playing}" = "[paused] " ]; then
            symbol="[=] "
            song="$(mpc current -f "%artist% - %title%")"
        elif [ ! "${playing}" = "[playing]" ]; then
            symbol="[?]"
        fi
    fi

    printf "%s%s" "${symbol}" "${song}"
}

update_info() {
    printf "%s" "$(checkupdates | wc -l)"
}

memory_info() {
    local meminfo=$(cat /proc/meminfo)

    local mem_total=$(printf "${meminfo}" | rg '^MemTotal' \
        | cut -f 2 -d ":" | sed -e 's/^[[:space:]]*//' | cut -f 1 -d " ")
    local mem_free=$(printf "${meminfo}" | rg '^MemFree' \
        | cut -f 2 -d ":" | sed -e 's/^[[:space:]]*//' | cut -f 1 -d " ")
    local buffers=$(printf "${meminfo}" | rg '^Buffers' \
        | cut -f 2 -d ":" | sed -e 's/^[[:space:]]*//' | cut -f 1 -d " ")
    local cached=$(printf "${meminfo}" | rg '^Cached' \
        | cut -f 2 -d ":" | sed -e 's/^[[:space:]]*//' | cut -f 1 -d " ")
    local slab=$(printf "${meminfo}" | rg '^Slab' \
        | cut -f 2 -d ":" | sed -e 's/^[[:space:]]*//' | cut -f 1 -d " ")

    # convert from KB to MB
    mem_total=$((mem_total / 1024))
    mem_free=$((mem_free / 1024))
    buffers=$((buffers / 1024))
    cached=$((cached / 1024))
    slab=$((slab / 1024))

    # calculate the memory usage according to:
    # https://access.redhat.com/solutions/406773
    local mem_used=$((mem_total - mem_free - buffers - cached - slab))

    printf "%s MB/%s MB" "${mem_used}" "${mem_total}"
}

loadavg_info() {
    # NOTE: it would be nice to divide the load averages with the CPU count
    #       which would negate the need for the CPU count in the status info
    #       and on every system a load average of 1.00 would be 100% load
    #       without needing to know the CPU count of the system.
    #
    #       There is no native way to do floating-point arithmetic in the shell!
    local cpu_count=$(cat /proc/cpuinfo | rg 'model name' | wc -l)
    local loadavg=$(cat /proc/loadavg | cut -d ' ' -f1,2,3)

    printf "%s (%s)" "${loadavg}" "${cpu_count}"
}

network_info() {
    local net_card=$(awk '$2 == 00000000 {printf $1}' /proc/net/route)
    local ip_addr=$(ip addr show ${net_card} | grep "inet\\b" | awk '{printf $2}' | cut -d/ -f1)

    if [ $ip_addr = "" ]; then
        ip_addr="NOT CONNECTED"
    fi

    printf "%s" "${ip_addr}"
}

clock_info() {
    # show date and time in japanese
    local locale="ja_JP.UTF-8"
    local current_time=$(LC_ALL=${locale} date "+%I:%M %p")

    printf "%s" "${current_time}"
}

spacer() {
    printf " :: "
}

main() {
    # to not check for updates every second
    local loop_counter=0
    local update_count="0"

    while true; do
        # after n seconds check for new updates
        if [ ${loop_counter} -eq 300 ]; then
            update_count="$(update_info)"
            loop_counter=0
        else
            loop_counter=$((loop_counter + 1))
        fi

        local buf=""

        buf="${buf}$(music_info)$(spacer)"
        buf="${buf}${update_count}$(spacer)"
        buf="${buf}$(loadavg_info)$(spacer)"
        buf="${buf}$(memory_info)$(spacer)"
        # buf="${buf}$(network_info)$(spacer)"
        buf="${buf}$(clock_info)"

        printf "%s \n" "${buf}"
        sleep 2
    done
}

main 2> /tmp/statusinfo.log
