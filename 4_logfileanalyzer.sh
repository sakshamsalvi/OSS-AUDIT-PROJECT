#!/bin/bash

# ==========================================================
# Script: Log File Analyzer
# Name: Saksham Salvi
#
# This script reads a log file and searches for a keyword
# (default: "error"). It counts how many times the keyword
# appears and shows the last few matching lines.
# ==========================================================

# -------- Input --------
log_file=$1
search_word=${2:-"error"}   # default keyword is "error"
match_count=0

echo "=============================================================="
echo "                    LOG FILE ANALYZER                         "
echo "=============================================================="
echo "Log file : ${log_file:-Not provided}"
echo "Keyword  : $search_word"
echo "--------------------------------------------------------------"

# -------- Check if file is provided --------
if [ -z "$log_file" ]; then
    echo "No log file given."
    echo "Usage: $0 <logfile> [keyword]"
    exit 1
fi

# -------- Try to access file (with retries) --------
max_attempts=3
attempt=0

while true; do

    if [ ! -f "$log_file" ]; then
        echo "File not found: $log_file"
        ((attempt++))

        if [ $attempt -ge $max_attempts ]; then
            echo "Stopping after $max_attempts failed attempts."
            exit 1
        fi

        echo "Retrying... ($attempt/$max_attempts)"
        sleep 2
        continue
    fi

    if [ ! -s "$log_file" ]; then
        echo "File exists but is empty."
        ((attempt++))

        if [ $attempt -ge $max_attempts ]; then
            echo "Still empty after retries. Exiting."
            exit 1
        fi

        echo "Trying again... ($attempt/$max_attempts)"
        sleep 2
        continue
    fi

    break
done

echo "File is ready. Starting scan..."
echo ""

# -------- Read file line by line --------
while IFS= read -r line; do
    if echo "$line" | grep -iq "$search_word"; then
        ((match_count++))
    fi
done < "$log_file"

# -------- Results --------
total_lines=$(wc -l < "$log_file")

echo "Total lines in file : $total_lines"
echo "Occurrences of '$search_word' : $match_count"
echo ""

echo "---------------- Last matching lines ----------------"

results=$(grep -i "$search_word" "$log_file" | tail -5)

if [ -n "$results" ]; then
    while IFS= read -r line; do
        echo "-> $line"
    done <<< "$results"
else
    echo "No matching lines found."
fi

echo "=============================================================="
echo "Analysis completed at $(date '+%I:%M:%S %p')"
echo "=============================================================="
