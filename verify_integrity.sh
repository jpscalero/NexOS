#!/bin/bash
# NexOS Integrity Verification Script v3.0
# This script checks the build environment and configuration files for errors.
# Run before every build to ensure all required assets and configs are present.

set -e

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
NC='\033[0m'

ERRORS=0
WARNINGS=0

check_file() {
    if [ -f "$1" ]; then
        echo -e "[${GREEN}OK${NC}] $1"
    else
        echo -e "[${RED}MISSING${NC}] $1"
        ERRORS=$((ERRORS + 1))
    fi
}

check_optional() {
    if [ -f "$1" ]; then
        echo -e "[${GREEN}OK${NC}] $1"
    else
        echo -e "[${YELLOW}OPTIONAL${NC}] $1"
        WARNINGS=$((WARNINGS + 1))
    fi
}

echo "============================================"
echo "  NexOS Integrity Verification v3.0"
echo "============================================"
echo ""

# 1. Core Build Scripts
echo "--- Core Build Scripts ---"
check_file "build_nexos.sh"
check_file "verify_integrity.sh"

# 2. Auto Scripts (Kali-style)
echo ""
echo "--- Auto Scripts (Kali-style) ---"
check_file "auto/config"
check_file "auto/build"
check_file "auto/clean"

# 3. Package Lists
echo ""
echo "--- Package Lists ---"
for list in desktop tools server pentesting; do
    check_file "config/package-lists/${list}.list.chroot"
done

# 4. Build Hooks
echo ""
echo "--- Build Hooks ---"
for hook in 00-system-branding 01-metasploit 02-user-setup 03-service-config \
            04-kde-custom 05-premium-ui 06-remove-debian-branding \
            07-calamares-config 08-live-config-fixups \
            10-force-nexos-branding 99-cleanup; do
    check_file "config/hooks/live/${hook}.chroot"
done

# 5. Visual Assets & Branding
echo ""
echo "--- Visual Assets & Branding ---"
check_file "assets/wallpaper-1920x1080.png"
check_file "assets/grub-splash-1920x1080.png"

# KDE Look and Feel
check_file "config/includes.chroot/usr/share/plasma/look-and-feel/org.kde.nexos.desktop/metadata.desktop"
check_file "config/includes.chroot/usr/share/plasma/look-and-feel/org.kde.nexos.desktop/contents/defaults"

# SDDM
check_file "config/includes.chroot/usr/share/sddm/themes/nexos-sddm/Main.qml"
check_file "config/includes.chroot/usr/share/sddm/themes/nexos-sddm/theme.conf"
check_file "config/includes.chroot/usr/share/sddm/themes/nexos-sddm/metadata.desktop"
check_file "config/includes.chroot/usr/share/sddm/themes/nexos-sddm/background.png"

# Plymouth
check_file "config/includes.chroot/usr/share/plymouth/themes/nexos/nexos.plymouth"
check_file "config/includes.chroot/usr/share/plymouth/themes/nexos/nexos.script"
check_file "config/includes.chroot/usr/share/plymouth/themes/nexos/logo.png"

# Wallpapers & Logos
check_file "config/includes.chroot/usr/share/pixmaps/nexos-logo.png"
check_file "config/includes.chroot/usr/share/wallpapers/nexos/wallpaper.png"

# 6. Boot Configuration
echo ""
echo "--- Boot Configuration ---"
check_file "config/includes.binary/boot/grub/grub.cfg"
check_file "config/includes.binary/boot/grub/splash.png"
check_file "config/includes.binary/isolinux/isolinux.cfg"
check_file "config/includes.binary/isolinux/splash.png"

# 7. System Configuration
echo ""
echo "--- System Configuration ---"
check_file "config/includes.chroot/etc/hostname"
check_file "config/includes.chroot/etc/hosts"
check_file "config/includes.chroot/etc/ssh/nexos-banner"
check_file "config/includes.chroot/etc/xdg/kdeglobals"
check_file "config/includes.chroot/etc/xdg/plasmarc"
check_file "config/includes.chroot/etc/default/grub"
check_file "config/includes.chroot/etc/plymouth/plymouthd.conf"

# 8. Live-Config
echo ""
echo "--- Live-Config ---"
check_file "config/includes.chroot/etc/live/config.conf.d/10-user-setup.conf"

# 9. User Environment (Skeleton)
echo ""
echo "--- User Environment (Skeleton) ---"
check_file "config/includes.chroot/etc/skel/.bashrc"
check_file "config/includes.chroot/etc/skel/.bash_profile"
check_file "config/includes.chroot/etc/skel/.config/kdeglobals"
check_file "config/includes.chroot/etc/skel/.config/konsolerc"
check_file "config/includes.chroot/etc/skel/.config/plasmarc"
check_file "config/includes.chroot/etc/skel/.config/plasma-org.kde.plasma.desktop-appletsrc"
check_file "config/includes.chroot/etc/skel/.local/share/konsole/NexOS.profile"

# 10. Governance & Documentation
echo ""
echo "--- Governance & Documentation ---"
for doc in README.md LICENSE SECURITY.md ROADMAP.md CREDITS.md CONTRIBUTING.md CODE_OF_CONDUCT.md CHANGELOG.md; do
    check_file "$doc"
done
check_file "docs/ARCHITECTURE.md"
check_file "docs/BUILD_GUIDE.md"

# 11. Syntax Check for all shell scripts
echo ""
echo "--- Shell Script Syntax Check ---"
for script in build_nexos.sh verify_integrity.sh auto/config auto/build auto/clean config/hooks/live/*.chroot; do
    if [ -f "$script" ]; then
        if bash -n "$script" 2>/dev/null; then
            echo -e "[${GREEN}OK${NC}] Syntax: $script"
        else
            echo -e "[${RED}FAIL${NC}] Syntax error: $script"
            ERRORS=$((ERRORS + 1))
        fi
    fi
done

# 12. Consistency Checks
echo ""
echo "--- Consistency Checks ---"

# Check Plymouth theme name matches plymouthd.conf
if [ -f "config/includes.chroot/etc/plymouth/plymouthd.conf" ]; then
    PLYMOUTH_THEME=$(grep "^Theme=" config/includes.chroot/etc/plymouth/plymouthd.conf | cut -d= -f2)
    if [ -d "config/includes.chroot/usr/share/plymouth/themes/$PLYMOUTH_THEME" ]; then
        echo -e "[${GREEN}OK${NC}] Plymouth theme '$PLYMOUTH_THEME' directory exists"
    else
        echo -e "[${RED}FAIL${NC}] Plymouth theme '$PLYMOUTH_THEME' directory missing"
        ERRORS=$((ERRORS + 1))
    fi
fi

# Check SDDM theme name matches sddm config
if [ -f "config/includes.chroot/etc/skel/.config/konsolerc" ]; then
    KONSOLE_PROFILE=$(grep "^DefaultProfile=" config/includes.chroot/etc/skel/.config/konsolerc | cut -d= -f2)
    PROFILE_PATH="config/includes.chroot/etc/skel/.local/share/konsole/$KONSOLE_PROFILE"
    if [ -f "$PROFILE_PATH" ]; then
        echo -e "[${GREEN}OK${NC}] Konsole profile '$KONSOLE_PROFILE' exists"
    else
        echo -e "[${RED}FAIL${NC}] Konsole profile '$KONSOLE_PROFILE' missing at $PROFILE_PATH"
        ERRORS=$((ERRORS + 1))
    fi
fi

# 13. Final Summary
echo ""
echo "============================================"
if [ $ERRORS -eq 0 ]; then
    if [ $WARNINGS -gt 0 ]; then
        echo -e "  ${GREEN}✅ All checks passed!${NC} ($WARNINGS optional warnings)"
    else
        echo -e "  ${GREEN}✅ All checks passed! Ready to build.${NC}"
    fi
else
    echo -e "  ${RED}❌ $ERRORS issue(s) found. Fix before building.${NC}"
fi
echo "============================================"

# Exit with error if issues found (will fail CI)
if [ $ERRORS -gt 0 ]; then
    exit 1
fi
