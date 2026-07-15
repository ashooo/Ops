#!/bin/bash

# =====
# SCRIPT: nginx-log-analyser.sh
# DESCRIPTION: Analyzes Nginx logs and extracts top traffic statistics using:
#   - IP ADDRESSES       : Identifies the most active client machines ($1)
#   - REQUEST PATHS      : Tracks the most heavily visited URLs on the site ($7)
#   - RESPONSE CODES     : Details standard HTTP status codes returned ($9)
#   - USER AGENTS        : Lists the web browsers and bots hitting the server ($6)
#
# Usage: ./nginx-log-analyser.sh [log_file_path] [top_count]
# Example: ./nginx-log-analyser.sh /var/log/nginx/access.log 10
# =====

path=${1:-/home/fluff/devops/nginx-access-log/nginx-access.log}
count=${2:-5}

getIp(){ awk '{print $1}' $path; }
getPath(){ awk '$7 ~ /^\// {print $7}' $path; }
getResCode(){ awk '$9 ~ /^[0-9]{3}/ {print $9}' $path; }
getUserAgent() { awk -F'"' '{print $6}' $path; }

printTop(){
        $1 | sort | uniq -c | sort -nr | awk -v width=${2:-0} '{ua=substr($0,index($0,$2)); printf "%" width "s - %d requests\n", ua, $1}' | head -n$count
}

echo === Top $count Ip addresses with the most requests ===
printTop getIp 15
echo
echo === Top $count most requested paths ==================
printTop getPath 20
echo
echo === Top $count response status codes =================
printTop getResCode 5
echo
echo === Top $count user agents ===========================
printTop getUserAgent