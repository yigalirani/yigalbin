#!/bin/bash

# Define the output file
OUTPUT_FILE="commits_week.csv"

# Write the header for the CSV file
echo "Week Start,million_try3_commits,filebrowser_commits" > $OUTPUT_FILE

# Loop over the last 52 weeks (1 year)
for i in {52..0}; do
    # Calculate the start and end dates of the week
    START_DATE=$(date -d "$((i * 7)) days ago" +%Y-%m-%d)
    END_DATE=$(date -d "$((i * 7 - 6)) days ago" +%Y-%m-%d)

    # Get the number of commits for each directory during that week
    MILLION_TRY3_COMMITS=$(git -C /c/yigal/million_try3 log --since="$START_DATE 00:00:00" --until="$END_DATE 23:59:59" --pretty=oneline | wc -l)
    FILEBROWSER_COMMITS=$(git -C /c/yigal/filebrowser log --since="$START_DATE 00:00:00" --until="$END_DATE 23:59:59" --pretty=oneline | wc -l)

    # Write the results to the CSV file
    echo "$START_DATE,$MILLION_TRY3_COMMITS,$FILEBROWSER_COMMITS" >> $OUTPUT_FILE
done

echo "Commit data has been written to $OUTPUT_FILE."
