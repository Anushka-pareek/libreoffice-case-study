#!/bin/bash
# =============================================================================
# Script 3: Disk and Permission Auditor
# Author:   Anushka Pareek | Roll: 24BCY10398
# Course:   Open Source Software (NGMC)
# Purpose:  Loops through key system directories and reports their disk usage,
#           ownership, and permissions. Also checks Git's config directory.
# Usage:    ./script3_disk_permission_auditor.sh
# =============================================================================

# --- Detect OS for du/ls compatibility (macOS vs GNU Linux) ---
OS_TYPE=$(uname -s)

# =============================================================================
# FUNCTION: get_dir_size
# Returns human-readable size of a directory.
# macOS 'du' doesn't support --exclude, so we use a simpler form.
# =============================================================================
get_dir_size() {
    local dir=$1
    # du -sh: summarize (-s) in human-readable format (-h)
    # 2>/dev/null suppresses "permission denied" errors
    du -sh "$dir" 2>/dev/null | cut -f1
}

# =============================================================================
# FUNCTION: get_permissions
# Returns "permissions owner group" string using ls -ld
# awk extracts fields: $1=perms, $3=owner, $4=group
# =============================================================================
get_permissions() {
    local dir=$1
    ls -ld "$dir" 2>/dev/null | awk '{print $1, "| owner:", $3, "| group:", $4}'
}

# =============================================================================
# FUNCTION: audit_directory
# Combines size + permissions into a single formatted block per directory
# =============================================================================
audit_directory() {
    local dir=$1

    # if [ -d "$dir" ] checks if the path exists and is a directory
    if [ -d "$dir" ]; then
        local size
        local perms
        size=$(get_dir_size "$dir")
        perms=$(get_permissions "$dir")

        echo "  📁 $dir"
        echo "     Size        : ${size:-unknown}"
        echo "     Permissions : $perms"
    else
        # Directory doesn't exist on this system — print a note
        echo "  ⚠  $dir — does not exist on this system"
    fi
    echo ""
}

# =============================================================================
# FUNCTION: check_git_dirs
# Specifically audits Git-related directories and config files
# =============================================================================
check_git_dirs() {
    echo "────────────────────────────────────────────────────────────"
    echo "  GIT-SPECIFIC DIRECTORY AUDIT"
    echo "────────────────────────────────────────────────────────────"
    echo ""

    # List of Git-related paths to check
    # These are standard locations where Git stores config and executables
    local git_paths=(
        "$HOME/.gitconfig"           # Global Git config for the current user
        "$HOME/.git-credentials"     # Stored credentials (if any)
        "/etc/gitconfig"             # System-wide Git config (Linux/macOS)
        "/usr/bin/git"               # Git binary on Linux
        "/usr/local/bin/git"         # Git binary on macOS (Homebrew)
        "/opt/homebrew/bin/git"      # Git binary on Apple Silicon Macs
    )

    for path in "${git_paths[@]}"; do
        if [ -e "$path" ]; then
            # -e checks existence of both files and directories
            local perms
            perms=$(ls -la "$path" 2>/dev/null | awk '{print $1, "| owner:", $3}')
            echo "  ✔ Found : $path"
            echo "    Perms  : $perms"
        else
            echo "  ✘ Not found : $path"
        fi
        echo ""
    done

    # Check if we're currently inside a Git repository
    if git rev-parse --is-inside-work-tree &>/dev/null; then
        local git_root
        git_root=$(git rev-parse --show-toplevel)
        echo "  ✔ Current directory is inside a Git repo:"
        echo "    Root : $git_root"
        echo "    .git size : $(get_dir_size "$git_root/.git")"
    else
        echo "  ℹ  Current directory is NOT a Git repository."
    fi
    echo ""
}

# =============================================================================
# MAIN EXECUTION
# =============================================================================
echo ""
echo "╔══════════════════════════════════════════════════════════╗"
echo "║           DISK AND PERMISSION AUDITOR                   ║"
echo "╚══════════════════════════════════════════════════════════╝"
echo ""
echo "  Platform: $OS_TYPE"
echo "  Run as  : $(whoami)"
echo "  Date    : $(date '+%d %B %Y %H:%M:%S')"
echo ""

# --- Standard system directories to audit ---
# These are important directories present on both macOS and Linux
DIRS=("/etc" "/var/log" "/home" "/usr/bin" "/tmp" "/usr")

echo "────────────────────────────────────────────────────────────"
echo "  SYSTEM DIRECTORY AUDIT"
echo "────────────────────────────────────────────────────────────"
echo ""

# for loop: iterates over each directory in the DIRS array
# "${DIRS[@]}" expands the full array safely (handles spaces in paths)
for DIR in "${DIRS[@]}"; do
    audit_directory "$DIR"
done

# --- macOS has /Users instead of /home ---
if [ "$OS_TYPE" = "Darwin" ]; then
    echo "  (macOS note: /home is empty — user homes live in /Users)"
    echo ""
    audit_directory "/Users"
fi

# --- Now audit Git-specific paths ---
check_git_dirs

echo "────────────────────────────────────────────────────────────"
echo "  Why permissions matter in open source:"
echo "  Git stores credentials and configs in user home dirs."
echo "  Misconfigured permissions can expose tokens and keys."
echo "────────────────────────────────────────────────────────────"
echo ""
