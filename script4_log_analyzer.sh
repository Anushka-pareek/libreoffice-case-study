#!/bin/bash
# =============================================================================
# Script 4: Log File Analyzer
# Author:   Anushka Pareek | Roll: 24BCY10398
# Course:   Open Source Software (NGMC)
# Purpose:  Reads a log file line by line, counts occurrences of a keyword,
#           shows the last 5 matching lines, and retries if the file is empty.
# Usage:    ./script4_log_analyzer.sh <logfile> [keyword]
#           Example: ./script4_log_analyzer.sh /var/log/syslog error
#           Example: ./script4_log_analyzer.sh git_activity.log push
# =============================================================================

# =============================================================================
# FUNCTION: usage
# Prints usage instructions and exits — called when arguments are wrong
# =============================================================================
usage() {
    echo ""
    echo "  Usage: $0 <logfile> [keyword]"
    echo ""
    echo "  Arguments:"
    echo "    logfile  — path to any text log file"
    echo "    keyword  — word to search for (default: error)"
    echo ""
    echo "  Examples:"
    echo "    $0 /var/log/syslog error"
    echo "    $0 /var/log/system.log WARNING"
    echo "    $0 git_activity.log push"
    echo ""
    exit 1
}

# =============================================================================
# FUNCTION: generate_sample_log
# Creates a sample git-activity log file for demo/testing purposes
# This ensures the script works even when no real log file is available
# =============================================================================
generate_sample_log() {
    local outfile=$1
    echo "Generating sample Git activity log: $outfile"
    echo ""

    # Heredoc (<<EOF) writes a multi-line block into the file
    cat > "$outfile" <<EOF
2024-01-15 09:01:12 INFO  git clone https://github.com/torvalds/linux.git
2024-01-15 09:03:44 INFO  git pull origin main — success
2024-01-15 09:15:22 ERROR fatal: repository 'https://github.com/fake/repo.git' not found
2024-01-15 09:22:08 WARNING merge conflict detected in src/main.c
2024-01-15 09:22:15 ERROR  Automatic merge failed — fix conflicts and commit
2024-01-15 09:35:01 INFO  git commit -m "fix: resolve merge conflict in main.c"
2024-01-15 10:00:00 INFO  git push origin main — success
2024-01-15 10:14:33 WARNING remote: Repository size approaching limit (4.8 GB / 5 GB)
2024-01-15 10:20:11 ERROR  error: failed to push some refs to 'origin'
2024-01-15 10:21:05 INFO  git fetch --all
2024-01-15 10:30:00 ERROR  SSL certificate problem: self-signed certificate
2024-01-15 11:00:00 INFO  git rebase main — no conflicts
2024-01-15 11:15:44 WARNING detached HEAD state — commits may be lost
2024-01-15 11:20:00 INFO  git checkout -b feature/open-source-audit
2024-01-15 11:45:00 INFO  git tag v1.0.0 — release tagged
EOF
}

# =============================================================================
# FUNCTION: analyze_log
# Core logic: reads file line by line, counts keyword matches, shows context
# =============================================================================
analyze_log() {
    local logfile=$1
    local keyword=$2

    local count=0           # Counter variable — incremented on each match
    local total_lines=0     # Total line count for stats

    echo "────────────────────────────────────────────────────────────"
    echo "  SCANNING LOG FILE"
    echo "────────────────────────────────────────────────────────────"
    echo "  File    : $logfile"
    echo "  Keyword : '$keyword' (case-insensitive)"
    echo ""

    # while read loop: reads the file one line at a time
    # IFS= preserves leading/trailing whitespace in each line
    # -r prevents backslash interpretation
    while IFS= read -r LINE; do
        total_lines=$((total_lines + 1))   # Increment total line counter

        # if-then: grep -iq does case-insensitive (-i) quiet (-q) match
        # -q means grep exits 0 (success) if found, 1 if not — no output printed
        if echo "$LINE" | grep -iq "$keyword"; then
            count=$((count + 1))           # Increment match counter
        fi

    done < "$logfile"   # Feed the file into the while loop via stdin redirection

    # --- Print summary ---
    echo "  Total lines scanned : $total_lines"
    echo "  Keyword matches     : $count"
    echo ""

    # --- Show last 5 matching lines using grep + tail ---
    echo "────────────────────────────────────────────────────────────"
    echo "  LAST 5 MATCHING LINES"
    echo "────────────────────────────────────────────────────────────"
    echo ""

    # grep -i: case-insensitive search across the whole file
    # tail -5: show only the last 5 results
    local matches
    matches=$(grep -i "$keyword" "$logfile" 2>/dev/null | tail -5)

    if [ -n "$matches" ]; then
        # -n checks if string is non-empty
        echo "$matches" | while IFS= read -r match_line; do
            echo "  → $match_line"
        done
    else
        echo "  No lines matched keyword '$keyword'."
    fi
    echo ""

    # --- Severity breakdown if keyword is generic ---
    if echo "$keyword" | grep -iq "error\|warning\|info"; then
        echo "────────────────────────────────────────────────────────────"
        echo "  SEVERITY BREAKDOWN"
        echo "────────────────────────────────────────────────────────────"
        echo "  ERROR lines   : $(grep -ic "error"   "$logfile" 2>/dev/null || echo 0)"
        echo "  WARNING lines : $(grep -ic "warning" "$logfile" 2>/dev/null || echo 0)"
        echo "  INFO lines    : $(grep -ic "info"    "$logfile" 2>/dev/null || echo 0)"
        echo ""
    fi
}

# =============================================================================
# MAIN EXECUTION
# =============================================================================
echo ""
echo "╔══════════════════════════════════════════════════════════╗"
echo "║                 LOG FILE ANALYZER                       ║"
echo "╚══════════════════════════════════════════════════════════╝"
echo ""

# $1 is the log file argument; $2 is the optional keyword
LOGFILE=$1
KEYWORD=${2:-"error"}    # Default to "error" if no keyword provided

# --- Validate input: no argument given → show usage ---
if [ -z "$LOGFILE" ]; then
    echo "  No log file specified. Generating a sample Git log for demo..."
    LOGFILE="/tmp/git_activity_sample.log"
    generate_sample_log "$LOGFILE"
fi

# --- Retry loop: if file is empty, offer to regenerate ---
# This simulates a do-while pattern using a while loop with a break condition
MAX_RETRIES=2
ATTEMPT=0

while [ $ATTEMPT -lt $MAX_RETRIES ]; do
    ATTEMPT=$((ATTEMPT + 1))

    # Check if the file exists and is not empty
    if [ ! -f "$LOGFILE" ]; then
        echo "  ✘ Attempt $ATTEMPT: File '$LOGFILE' not found."
        if [ $ATTEMPT -lt $MAX_RETRIES ]; then
            echo "  Generating sample log and retrying..."
            LOGFILE="/tmp/git_activity_sample.log"
            generate_sample_log "$LOGFILE"
        else
            echo "  ✘ Could not find or create log file. Exiting."
            exit 1
        fi

    elif [ ! -s "$LOGFILE" ]; then
        # -s checks if file has size > 0
        echo "  ✘ Attempt $ATTEMPT: File '$LOGFILE' exists but is empty."
        if [ $ATTEMPT -lt $MAX_RETRIES ]; then
            echo "  Regenerating sample log and retrying..."
            generate_sample_log "$LOGFILE"
        else
            echo "  ✘ File remains empty after retry. Exiting."
            exit 1
        fi
    else
        # File exists and has content — proceed with analysis
        break
    fi
done

# --- Run the analysis ---
analyze_log "$LOGFILE" "$KEYWORD"

echo "────────────────────────────────────────────────────────────"
echo "  Git Connection: Open source projects rely on transparent"
echo "  logs. Git's commit history is itself a public audit trail"
echo "  — every change, author, and decision is logged forever."
echo "────────────────────────────────────────────────────────────"
echo ""
