#!/bin/sh

# Usage: sh log_analyzer.sh <log_file>

LOG=$1

if [ -z "$LOG" ]; then
    echo "Usage: sh log_analyzer.sh <log_file>"
    exit 1
fi

if [ ! -f "$LOG" ]; then
    echo "ERROR: Log file $LOG not found"
    exit 1
fi

echo "---- Web Server Log Analysis Report ----"
echo ""

echo "Total requests:"
wc -l < "$LOG"
echo ""

echo "Top 5 most requested pages:"
awk '{print $7}' "$LOG" | sort | uniq -c | sort -rn | head -5
echo ""

echo "Top 5 IP addresses by request count:"
awk '{print $1}' "$LOG" | sort | uniq -c | sort -rn | head -5
echo ""

echo "Total 404 errors:"
grep -c " 404 " "$LOG"
echo ""

echo "Top 5 pages returning 404:"
grep " 404 " "$LOG" | awk '{print $7}' | sort | uniq -c | sort -rn | head -5
echo ""

echo "---- Report Complete ----"