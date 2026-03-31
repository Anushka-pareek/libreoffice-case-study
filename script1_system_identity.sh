#!/bin/bash
# =============================================================================
# Script 1: System Identity Report
# Author:   Anushka Pareek | Roll: 24BCY10398
# Course:   Open Source Software (NGMC)
# Purpose:  Displays a welcome-screen style summary of the current system,
#           including kernel version, user info, uptime, and OSS license info.
# Usage:    ./script1_system_identity.sh
# =============================================================================

# --- Configuration ---
STUDENT_NAME="Anushka Pareek"         
REG_NUMBER="24BCY10398"   
SOFTWARE_CHOICE="Git"              # The OSS project being audited

# --- Detect OS (macOS vs Linux) ---
# uname returns "Darwin" on macOS and "Linux" on Linux
OS_TYPE=$(uname -s)

# --- Gather system information using command substitution $() ---
KERNEL=$(uname -r)                          # Kernel/OS release version
USER_NAME=$(whoami)                         # Currently logged-in user
HOME_DIR=$HOME                              # Home directory from env variable
CURRENT_DATE=$(date '+%A, %d %B %Y')        # Human-readable date
CURRENT_TIME=$(date '+%H:%M:%S')            # Current time in HH:MM:SS

# --- Get uptime in a readable format (differs between macOS and Linux) ---
if [ "$OS_TYPE" = "Darwin" ]; then
    # macOS: uptime outputs differently, we parse it manually
    UPTIME=$(uptime | awk -F'up ' '{print $2}' | awk -F',' '{print $1}' | xargs)
    DISTRO="macOS $(sw_vers -productVersion)"
    OS_LICENSE="macOS is proprietary (Darwin/XNU kernel is open source — Apache 2.0)"
else
    # Linux: uptime -p gives a clean "up X hours, Y minutes" format
    UPTIME=$(uptime -p 2>/dev/null || uptime)
    # Read distro name from the standard os-release file
    if [ -f /etc/os-release ]; then
        DISTRO=$(grep ^PRETTY_NAME /etc/os-release | cut -d= -f2 | tr -d '"')
    else
        DISTRO="Unknown Linux"
    fi
    OS_LICENSE="Linux Kernel is licensed under GNU GPL v2 (Free and Open Source)"
fi

# --- Display the identity report ---
echo ""
echo "╔══════════════════════════════════════════════════════════╗"
echo "║           OPEN SOURCE AUDIT — SYSTEM IDENTITY           ║"
echo "╚══════════════════════════════════════════════════════════╝"
echo ""
echo "  Student  : $STUDENT_NAME ($ROLL_NUMBER)"
echo "  Project  : OSS Audit — $SOFTWARE_CHOICE"
echo ""
echo "────────────────────────────────────────────────────────────"
echo "  SYSTEM INFORMATION"
echo "────────────────────────────────────────────────────────────"
echo "  OS / Distro  : $DISTRO"
echo "  Kernel       : $KERNEL"
echo "  Logged in as : $USER_NAME"
echo "  Home Dir     : $HOME_DIR"
echo "  Uptime       : $UPTIME"
echo "  Date         : $CURRENT_DATE"
echo "  Time         : $CURRENT_TIME"
echo ""
echo "────────────────────────────────────────────────────────────"
echo "  OPEN SOURCE LICENSE NOTE"
echo "────────────────────────────────────────────────────────────"
echo "  $OS_LICENSE"
echo "  Git is licensed under GNU GPL v2."
echo "  This means: free to use, study, modify, and distribute."
echo ""
echo "╔══════════════════════════════════════════════════════════╗"
echo "║         'Freedom is not given — it is licensed.'        ║"
echo "╚══════════════════════════════════════════════════════════╝"
echo ""
