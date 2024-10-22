#!/bin/bash

# Define the output file
OUTPUT_FILE="commits.csv"

# Write the header for the CSV file
echo "Date,million_try3_commits,filebrowser_commits" > $OUTPUT_FILE

# Get the list of dates in the past year
for i in {365..0}; do
    DATE=$(date -d "$i days ago" +%Y-%m-%d)

    # Get the number of commits for each directory on that date
    MILLION_TRY3_COMMITS=$(git -C /c/yigal/million_try3 log --since="$DATE 00:00:00" --until="$DATE 23:59:59" --pretty=oneline | wc -l)
    FILEBROWSER_COMMITS=$(git -C /c/yigal/filebrowser log --since="$DATE 00:00:00" --until="$DATE 23:59:59" --pretty=oneline | wc -l)

    # Write the results to the CSV file
    echo "$DATE,$MILLION_TRY3_COMMITS,$FILEBROWSER_COMMITS" >> $OUTPUT_FILE
done

echo "Commit data has been written to $OUTPUT_FILE."
