#!/bin/bash
# =============================================================================
# Script 5: Open Source Manifesto Generator
# Author:   Anushka Pareek | Roll: 24BCY10398
# Course:   Open Source Software (NGMC)
# Purpose:  Interactively collects three answers from the user and generates
#           a personalised open-source philosophy statement saved to a .txt file.
# Usage:    ./script5_manifesto_generator.sh
#
# Alias concept (demonstrated in comments):
#   In practice, you might alias this script for quick access:
#   alias manifesto='bash ~/scripts/script5_manifesto_generator.sh'
#   Then just type: manifesto
# =============================================================================

# =============================================================================
# FUNCTION: print_header
# Displays the title banner
# =============================================================================
print_header() {
    echo ""
    echo "╔══════════════════════════════════════════════════════════╗"
    echo "║         OPEN SOURCE MANIFESTO GENERATOR                 ║"
    echo "║              Powered by: Git & GNU Bash                 ║"
    echo "╚══════════════════════════════════════════════════════════╝"
    echo ""
    echo "  This script will create your personal open-source manifesto."
    echo "  Answer three questions honestly. There are no wrong answers."
    echo ""
    echo "────────────────────────────────────────────────────────────"
    echo ""
}

# =============================================================================
# FUNCTION: get_input
# Prompts the user and reads their answer, retrying if they leave it blank
# =============================================================================
get_input() {
    local prompt=$1      # The question to display
    local varname=$2     # Name of the variable to store the answer in
    local answer=""

    # Loop until a non-empty answer is entered
    while [ -z "$answer" ]; do
        # read -p: print prompt and wait for user input on the same line
        read -p "  $prompt " answer

        if [ -z "$answer" ]; then
            echo "  ⚠  Please enter an answer to continue."
            echo ""
        fi
    done

    # Use eval to dynamically assign value to variable named $varname
    eval "$varname=\"$answer\""
}

# =============================================================================
# FUNCTION: compose_manifesto
# Builds the manifesto paragraph using string concatenation
# =============================================================================
compose_manifesto() {
    local tool=$1
    local freedom=$2
    local build=$3
    local author=$4
    local date=$5

    # String concatenation in bash: just place variables next to text
    # Each echo >> appends a line to the output file
    local outfile="manifesto_${author}.txt"

    # Write the manifesto header to file using > (overwrites if exists)
    echo "============================================================" > "$outfile"
    echo "  MY OPEN SOURCE MANIFESTO" >> "$outfile"
    echo "  Author : $author" >> "$outfile"
    echo "  Date   : $date" >> "$outfile"
    echo "  Course : Open Source Software — OSS Audit (Git)" >> "$outfile"
    echo "============================================================" >> "$outfile"
    echo "" >> "$outfile"

    # Compose the main paragraph using the three user answers
    # String building: variables are embedded directly in double-quoted strings
    echo "I believe in open source because I have seen what it can do." >> "$outfile"
    echo "" >> "$outfile"
    echo "Every day, I rely on $tool — a tool that exists not because" >> "$outfile"
    echo "a corporation decided to sell it, but because someone chose to" >> "$outfile"
    echo "share it. That choice — quiet, deliberate, unrewarded by profit —" >> "$outfile"
    echo "changed the world. It changed mine." >> "$outfile"
    echo "" >> "$outfile"
    echo "To me, freedom means $freedom. In software, that freedom is real:" >> "$outfile"
    echo "the freedom to read the code, to change it, to share it, and to" >> "$outfile"
    echo "build on it without asking permission. That is not a small thing." >> "$outfile"
    echo "Most of the world's knowledge is locked behind paywalls, NDAs," >> "$outfile"
    echo "and proprietary walls. Open source is a crack in that wall." >> "$outfile"
    echo "" >> "$outfile"
    echo "I commit to contributing back. One day, I will build $build" >> "$outfile"
    echo "and I will share it. Not because I have to. Because I remember" >> "$outfile"
    echo "that every tool I have ever used was a gift from someone I never met." >> "$outfile"
    echo "" >> "$outfile"
    echo "Linus Torvalds didn't keep the kernel. Guido van Rossum didn't" >> "$outfile"
    echo "sell Python. The Apache team didn't lock the web server behind a" >> "$outfile"
    echo "license fee. They gave it away — and the world was built on that gift." >> "$outfile"
    echo "" >> "$outfile"
    echo "This is my commitment: to use freely, to learn openly, and to give back." >> "$outfile"
    echo "" >> "$outfile"
    echo "                                    — $author, $date" >> "$outfile"
    echo "" >> "$outfile"
    echo "============================================================" >> "$outfile"

    echo "$outfile"   # Return the filename
}

# =============================================================================
# MAIN EXECUTION
# =============================================================================

print_header

# --- Collect three answers interactively using read ---
echo "  Question 1 of 3:"
get_input "Name one open-source tool you use every day:" TOOL

echo ""
echo "  Question 2 of 3:"
get_input "In one word, what does 'freedom' mean to you?" FREEDOM

echo ""
echo "  Question 3 of 3:"
get_input "Name one thing you would build and share freely with the world:" BUILD

echo ""
echo "────────────────────────────────────────────────────────────"
echo "  Composing your manifesto..."
echo "────────────────────────────────────────────────────────────"
echo ""

# --- Get current date and username for the manifesto header ---
DATE=$(date '+%d %B %Y')           # e.g. "15 January 2025"
AUTHOR=$(whoami)                   # Current logged-in username

# --- Generate the manifesto file ---
OUTPUT_FILE=$(compose_manifesto "$TOOL" "$FREEDOM" "$BUILD" "$AUTHOR" "$DATE")

echo "  ✔ Manifesto saved to: $OUTPUT_FILE"
echo ""
echo "────────────────────────────────────────────────────────────"
echo "  YOUR MANIFESTO"
echo "────────────────────────────────────────────────────────────"
echo ""

# cat reads and displays the file contents to stdout
cat "$OUTPUT_FILE"

echo ""
echo "────────────────────────────────────────────────────────────"
echo "  Alias tip (add to your ~/.bashrc or ~/.zshrc):"
echo "  alias manifesto='bash $(pwd)/script5_manifesto_generator.sh'"
echo "────────────────────────────────────────────────────────────"
echo ""
