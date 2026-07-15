#!/bin/bash

# =====
# SCRIPT: server_stats.sh
# DESCRIPTION: Prints out server utilization stats using the following fields:
#   - CPU: PID, COMMAND, USER, %CPU (Top processes by processing power)
#   - MEMORY: Free, Used, Total (RAM blocks and usage percentages)
#   - DISK: PATH, SIZE, USED, FREE, USED% (WSL mounted Windows drives)
#   - PROCESS MEMORY: PID, COMMAND, USER, %MEM (Top processes by RAM usage)
# =====

getCpuUsage() {
    read cpu u1 n1 s1 i1 w1 q1 sq1 st1 _ < /proc/stat
    total1=$((u1 + n1 + s1 + i1 + w1 + q1 + sq1 + st1))
    idle1=$((i1 + w1))

    sleep 1

    read cpu u2 n2 s2 i2 w2 q2 sq2 st2 _ < /proc/stat
    total2=$((u2 + n2 + s2 + i2 + w2 + q2 + sq2 + st2))
    idle2=$((i2 + w2))

    total_diff=$((total2 - total1))
    idle_diff=$((idle2 - idle1))

    cpu_usage=$(( (100 * (total_diff - idle_diff)) / total_diff ))

    printf "\n== CPU USAGE =========\n"
    printf "Total CPU Usage : %d%%\n" "$cpu_usage"
    printf "=====================\n"
}

getMemoryUsage(){
        local TOTAL USED FREE SHARED CACHE AVAILABLE
        local FREE_PERCENTAGE USED_PERCENTAGE

        read TOTAL USED FREE SHARED CACHE AVAILABLE <<< $(free | awk 'NR==2 { $1=""; print $0 }')
        FREE_PERCENTAGE=$(echo "scale=2; ( $FREE / $TOTAL ) * 100" | bc)
        USED_PERCENTAGE=$(echo "scale=2; ( $USED / $TOTAL ) * 100" | bc)

printf "\n== MEMORY USAGE =====\n"
printf "%-6s : %6s  %6s%%\n" "Free" $FREE $FREE_PERCENTAGE
printf "%-6s : %6s  %6s%%\n" "Used" $USED $USED_PERCENTAGE
printf "%-6s : %6s\n" "Total" $TOTAL
printf "=====================\n"
}

getDiskUsage(){
printf "\n== DISK USAGE =======\n"
        printf "%-6s %6s %6s %6s %6s\n" "PATH" "SIZE" "USED" "FREE" "USED%"
        df | awk '$6 ~ "^/mnt/[a-z]$"' | while read LINE; do
                read PATH SIZE USED FREE USEp MOUNT <<< "$LINE"
        done
printf "=====================\n"
}

getCpuUsage(){
printf "\n== CPU USAGE ========\n"
ps -eo pid,comm,user,%cpu --sort=-%cpu | head -n6
printf "=====================\n"
}

getMemUsage(){
printf "\n== CPU USAGE ========\n"
ps -eo pid,comm,user,%mem --sort=-%mem | head -n6
printf "=====================\n"
}

getCpuUsage
getMemoryUsage
getDiskUsage
getCpuUsage
getMemUsage