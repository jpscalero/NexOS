#!/bin/bash
# NexOS Build Script
# This script orchestrates the creation of the NexOS ISO using live-build.
# Configuration is delegated to auto/config (Kali-style).

set -e

# Colors for logs
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

log() { echo -e "${BLUE}[NexOS]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }

# Root check
if [ "$EUID" -ne 0 ]; then
    error "Please run as root (use sudo)."
fi

# Ensure non-interactive mode
export DEBIAN_FRONTEND=noninteractive

# 1. Install dependencies if not present
log "Ensuring build dependencies are installed..."
apt-get update -qq
apt-get install -y -qq \
    live-build debootstrap curl \
    isolinux syslinux-common syslinux-efi \
    xorriso dos2unix

# 2. Normalize line endings (critical when building from Windows-cloned repos)
log "Normalizing line endings..."
find . -type f \( -name "*.sh" -o -name "*.chroot" -o -name "*.conf" \) -exec dos2unix {} + 2>/dev/null || true
find ./auto -type f -exec dos2unix {} + 2>/dev/null || true

# 3. Ensure auto scripts are executable
chmod +x auto/config auto/build auto/clean 2>/dev/null || true
chmod +x config/hooks/live/*.chroot 2>/dev/null || true

# 4. Clean previous build
log "Cleaning previous build state..."
lb clean --all 2>/dev/null || true

# 5. Run lb config via auto/config
log "Configuring live-build (via auto/config)..."
lb config

# 6. Run the build
log "Starting the build process. This may take 20-45 minutes..."
lb build 2>&1 | tee build.log

# 7. Find and rename the generated ISO
GENERATED_ISO=$(ls *.iso 2>/dev/null | head -n 1)

if [ -n "$GENERATED_ISO" ]; then
    FINAL_NAME="nexos-v1-amd64.iso"
    if [ "$GENERATED_ISO" != "$FINAL_NAME" ]; then
        mv "$GENERATED_ISO" "$FINAL_NAME"
    fi

    # Generate checksums
    log "Generating checksums..."
    sha256sum "$FINAL_NAME" > "${FINAL_NAME}.sha256"
    md5sum "$FINAL_NAME" > "${FINAL_NAME}.md5"

    ISO_SIZE=$(du -h "$FINAL_NAME" | cut -f1)
    log "${GREEN}Build successful!${NC}"
    log "  ISO: $FINAL_NAME ($ISO_SIZE)"
    log "  SHA256: $(cat ${FINAL_NAME}.sha256)"
else
    error "ISO was not generated. Check build.log for specific errors."
fi
