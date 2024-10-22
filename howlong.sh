#!/bin/bash

# ANSI color codes
GREEN='\033[0;92m'
YELLOW='\033[0;93m'
RED='\033[0;91m'
NC='\033[0m' # No Color

# Array of Git directories
directories=(
    "/c/yigal/million_try3"
    "/c/yigal/filebrowser"
)

# Function to get time since last commit and commit message
get_last_commit_info() {
    local dir=$1
    cd "$dir" || exit 1
    
    # Get the timestamp and message of the last commit
    last_commit_info=$(git log -1 --format="%ct%n%s" 2>/dev/null)
    
    if [ -z "$last_commit_info" ]; then
        echo "$(basename "$dir"): No commits found"
    else
        # Split the output into timestamp and message
        last_commit_timestamp=$(echo "$last_commit_info" | sed -n '1p')
        commit_message=$(echo "$last_commit_info" | sed -n '2p')
        
        # Calculate the time difference
        current_timestamp=$(date +%s)
        seconds_since_last_commit=$((current_timestamp - last_commit_timestamp))
        
        # Convert seconds to a more readable format and set color
        if [ $seconds_since_last_commit -le 3600 ]; then
            # 1 hour or less
            color=$GREEN
            if [ $seconds_since_last_commit -lt 60 ]; then
                time_ago="$seconds_since_last_commit seconds ago"
            else
                minutes=$((seconds_since_last_commit / 60))
                time_ago="$minutes minutes ago"
            fi
        elif [ $seconds_since_last_commit -le 86400 ]; then
            # 24 hours or less
            color=$YELLOW
            hours=$((seconds_since_last_commit / 3600))
            time_ago="$hours hours ago"
        else
            # More than 24 hours
            color=$RED
            days=$((seconds_since_last_commit / 86400))
            time_ago="$days days ago"
        fi
        
        echo -e "$(basename "$dir"): ${color}$time_ago${NC} - $commit_message"
    fi
}

# Iterate through the directories and get last commit info for each
for dir in "${directories[@]}"; do
    get_last_commit_info "$dir"
done