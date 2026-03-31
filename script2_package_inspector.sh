#!/bin/bash
# =============================================================================
# Script 2: FOSS Package Inspector
# Author:   Anushka Pareek | Roll: 24BCY10398
# Course:   Open Source Software (NGMC)
# Purpose:  Checks if a given FOSS package is installed, displays its version
#           and license info, and prints a philosophy note using a case statement.
# Usage:    ./script2_package_inspector.sh [package-name]
#           Example: ./script2_package_inspector.sh git
# =============================================================================

# --- Accept package name as argument, default to "git" if none provided ---
# $1 is the first command-line argument; ${1:-git} uses "git" as fallback
PACKAGE=${1:-git}

# --- Detect operating system to choose the right package manager ---
OS_TYPE=$(uname -s)

# =============================================================================
# FUNCTION: check_package_linux
# Uses rpm (Red Hat/Fedora) or dpkg (Debian/Ubuntu) to check installation
# =============================================================================
check_package_linux() {
    local pkg=$1

    # Try rpm first (Fedora/RHEL/CentOS), then fall back to dpkg (Debian/Ubuntu)
    if command -v rpm &>/dev/null; then
        if rpm -q "$pkg" &>/dev/null; then
            echo "  ✔ '$pkg' is INSTALLED (detected via rpm)"
            echo ""
            echo "  Package Details:"
            # rpm -qi gives full info; grep filters to key fields only
            rpm -qi "$pkg" 2>/dev/null | grep -E 'Version|License|Summary|URL' | \
                sed 's/^/    /'
        else
            echo "  ✘ '$pkg' is NOT installed (checked via rpm)"
        fi

    elif command -v dpkg &>/dev/null; then
        if dpkg -l "$pkg" 2>/dev/null | grep -q "^ii"; then
            echo "  ✔ '$pkg' is INSTALLED (detected via dpkg)"
            echo ""
            echo "  Package Details:"
            # dpkg -s gives status and metadata for the package
            dpkg -s "$pkg" 2>/dev/null | grep -E 'Version|Homepage|Description' | \
                sed 's/^/    /'
        else
            echo "  ✘ '$pkg' is NOT installed (checked via dpkg)"
        fi
    else
        echo "  ⚠ No supported package manager found (rpm/dpkg)."
    fi
}

# =============================================================================
# FUNCTION: check_package_mac
# Uses Homebrew (brew) — the standard package manager on macOS
# =============================================================================
check_package_mac() {
    local pkg=$1

    # Check if brew is available at all
    if ! command -v brew &>/dev/null; then
        echo "  ⚠ Homebrew not found. Install from https://brew.sh"
        # Even without brew, check if the binary exists in PATH
        if command -v "$pkg" &>/dev/null; then
            echo "  ✔ '$pkg' binary found in PATH (may be system-installed)"
            echo "    Version: $($pkg --version 2>/dev/null | head -1)"
        fi
        return
    fi

    # Use brew list to check if package is managed by Homebrew
    if brew list "$pkg" &>/dev/null; then
        echo "  ✔ '$pkg' is INSTALLED (managed by Homebrew)"
        echo ""
        echo "  Package Details:"
        # brew info gives description, version, and homepage
        brew info "$pkg" 2>/dev/null | head -6 | sed 's/^/    /'
    else
        # Package might exist in PATH even if not in brew (e.g., Apple's built-in git)
        if command -v "$pkg" &>/dev/null; then
            echo "  ✔ '$pkg' binary found in PATH (system/Xcode version, not Homebrew)"
            echo "    Version: $($pkg --version 2>/dev/null | head -1)"
        else
            echo "  ✘ '$pkg' is NOT installed"
        fi
    fi
}

# =============================================================================
# FUNCTION: print_philosophy
# Case statement that prints a philosophy note based on the package name
# =============================================================================
print_philosophy() {
    local pkg=$1

    echo ""
    echo "────────────────────────────────────────────────────────────"
    echo "  OPEN SOURCE PHILOSOPHY NOTE"
    echo "────────────────────────────────────────────────────────────"

    # case statement matches the package name to a philosophy message
    case "$pkg" in
        git)
            echo "  Git — Linus Torvalds built Git in 2 weeks after BitKeeper"
            echo "  revoked free access to Linux developers. A proprietary tool"
            echo "  held the Linux kernel hostage — so the community built their"
            echo "  own. Today, Git is the backbone of all modern software dev."
            ;;
        httpd | apache2)
            echo "  Apache — The web server that proved open source could power"
            echo "  the internet. It runs ~30% of all websites and pioneered the"
            echo "  Apache License, one of the most permissive in open source."
            ;;
        mysql | mariadb)
            echo "  MySQL — A dual-license story: free for open source projects,"
            echo "  commercial license for proprietary use. When Oracle acquired"
            echo "  MySQL, the community forked it into MariaDB — freedom in action."
            ;;
        python3 | python)
            echo "  Python — Shaped entirely by community PEPs (proposals). No"
            echo "  single company controls it. The PSF license ensures Python"
            echo "  remains a shared resource for humanity."
            ;;
        vlc)
            echo "  VLC — Built by students at École Centrale Paris who just wanted"
            echo "  to stream video on their campus network. Now it plays every"
            echo "  codec ever made. LGPL means even commercial apps can use it."
            ;;
        firefox)
            echo "  Firefox — A nonprofit browser fighting for an open web against"
            echo "  corporate monocultures. Mozilla exists to prove that a browser"
            echo "  can serve users instead of advertisers."
            ;;
        libreoffice)
            echo "  LibreOffice — Born from a community revolt against Oracle's"
            echo "  acquisition of OpenOffice. The community forked, and the fork"
            echo "  won. A living proof that open source governance matters."
            ;;
        *)
            # Default case for any unrecognised package
            echo "  '$pkg' — Every open-source tool carries a story of someone"
            echo "  choosing to share rather than sell. That choice changes the world."
            ;;
    esac
    echo ""
}

# =============================================================================
# MAIN EXECUTION
# =============================================================================
echo ""
echo "╔══════════════════════════════════════════════════════════╗"
echo "║              FOSS PACKAGE INSPECTOR                     ║"
echo "╚══════════════════════════════════════════════════════════╝"
echo ""
echo "  Inspecting package: $PACKAGE"
echo "  Platform detected : $OS_TYPE"
echo ""
echo "────────────────────────────────────────────────────────────"
echo "  INSTALLATION STATUS"
echo "────────────────────────────────────────────────────────────"

# Route to the correct check function based on OS
if [ "$OS_TYPE" = "Darwin" ]; then
    check_package_mac "$PACKAGE"
else
    check_package_linux "$PACKAGE"
fi

# Always print the philosophy note regardless of OS
print_philosophy "$PACKAGE"
