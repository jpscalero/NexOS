#!/bin/bash
# NexOS Integrity Verification Script
# This script checks the build environment and configuration files for errors.

set -e

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

check_file() {
    if [ -f "$1" ]; then
        echo -e "[${GREEN}OK${NC}] File found: $1"
    else
        echo -e "[${RED}MISSING${NC}] File not found: $1"
        return 1
    fi
}

echo "Starting NexOS Integrity Check..."

# Check main script
check_file "build_nexos.sh"

# Check package lists
for list in desktop general server pentesting; do
    check_file "config/package-lists/${list}.list.chroot"
done

# Check hooks
for hook in 01-metasploit 02-user-setup 03-service-config 04-kde-custom; do
    check_file "config/hooks/live/${hook}.chroot"
done

# Check assets
check_file "assets/wallpaper.png"
check_file "config/includes.chroot/usr/share/wallpapers/nexos/wallpaper.png"

# Check hostname/hosts
check_file "config/includes.chroot/etc/hostname"
check_file "config/includes.chroot/etc/hosts"

# Basic syntax check for shell scripts
echo "Checking script syntax..."
for script in build_nexos.sh config/hooks/live/*.chroot; do
    bash -n "$script" && echo -e "[${GREEN}OK${NC}] Syntax check: $script" || echo -e "[${RED}FAIL${NC}] Syntax error: $script"
done

echo -e "\n${GREEN}Integrity check complete.${NC}"
