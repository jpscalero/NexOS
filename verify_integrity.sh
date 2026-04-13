#!/bin/bash
# NexOS Integrity Verification Script
# This script checks the build environment and configuration files for errors.
# Run before every build to ensure all required assets and configs are present.

set -e

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
NC='\033[0m'

ERRORS=0

check_file() {
    if [ -f "$1" ]; then
        echo -e "[${GREEN}OK${NC}] $1"
    else
        echo -e "[${RED}MISSING${NC}] $1"
        ERRORS=$((ERRORS + 1))
    fi
}

echo "============================================"
echo "  NexOS Integrity Verification v2.0"
echo "============================================"
echo ""

# 1. Core Build Scripts
echo "--- Core Build Scripts ---"
check_file "build_nexos.sh"
check_file "verify_integrity.sh"

# 2. Package Lists
echo ""
echo "--- Package Lists ---"
for list in desktop general server pentesting; do
    check_file "config/package-lists/${list}.list.chroot"
done

# 3. Build Hooks
echo ""
echo "--- Build Hooks ---"
for hook in 00-system-branding 01-metasploit 02-user-setup 03-service-config 04-kde-custom 05-premium-ui 10-force-nexos-branding 99-cleanup; do
    check_file "config/hooks/live/${hook}.chroot"
done

# 4. Visual Assets & Branding
echo ""
echo "--- Visual Assets & Branding ---"
check_file "assets/wallpaper.png"
check_file "docs/img/logo.png"
check_file "config/includes.chroot/usr/share/plasma/look-and-feel/org.kde.nexos.desktop/metadata.desktop"
check_file "docs/img/banner.png"
check_file "config/includes.binary/boot/grub/grub.cfg"
check_file "config/includes.binary/boot/grub/splash.png"
check_file "config/includes.chroot/usr/share/pixmaps/nexos-logo.png"
check_file "config/includes.chroot/usr/share/wallpapers/nexos/wallpaper.png"

# 5. System Configuration
echo ""
echo "--- System Configuration ---"
check_file "config/includes.chroot/etc/hostname"
check_file "config/includes.chroot/etc/hosts"
check_file "config/includes.chroot/etc/ssh/nexos-banner"
check_file "config/includes.chroot/etc/xdg/kdeglobals"
check_file "config/includes.chroot/etc/xdg/plasmarc"

# 6. User Environment (Skeleton)
echo ""
echo "--- User Environment (Skeleton) ---"
check_file "config/includes.chroot/etc/skel/.bashrc"
check_file "config/includes.chroot/etc/skel/.bash_profile"
check_file "config/includes.chroot/etc/skel/.config/kdeglobals"
check_file "config/includes.chroot/etc/skel/.config/konsolerc"
check_file "config/includes.chroot/etc/skel/.config/plasma-org.kde.plasma.desktop-appletsrc"

# 7. Governance & Documentation
echo ""
echo "--- Governance & Documentation ---"
for doc in README.md LICENSE SECURITY.md ROADMAP.md CREDITS.md CONTRIBUTING.md CODE_OF_CONDUCT.md CHANGELOG.md; do
    check_file "$doc"
done
check_file "docs/ARCHITECTURE.md"
check_file "docs/BUILD_GUIDE.md"

# 8. Syntax Check for all shell scripts
echo ""
echo "--- Shell Script Syntax Check ---"
for script in build_nexos.sh verify_integrity.sh config/hooks/live/*.chroot; do
    if [ -f "$script" ]; then
        if bash -n "$script" 2>/dev/null; then
            echo -e "[${GREEN}OK${NC}] Syntax: $script"
        else
            echo -e "[${RED}FAIL${NC}] Syntax error: $script"
            ERRORS=$((ERRORS + 1))
        fi
    fi
done

# 9. Final Summary
echo ""
echo "============================================"
if [ $ERRORS -eq 0 ]; then
    echo -e "  ${GREEN}✅ All checks passed! Ready to build.${NC}"
else
    echo -e "  ${RED}❌ $ERRORS issue(s) found. Fix before building.${NC}"
fi
echo "============================================"

# Exit with error if issues found (will fail CI)
if [ $ERRORS -gt 0 ]; then
    exit 1
fi
