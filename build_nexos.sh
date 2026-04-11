#!/bin/bash
# NexOS Build Script
# This script orchestrates the creation of the NexOS ISO using live-build.

set -e

# Colors for logs
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

log() { echo -e "${BLUE}[NexOS]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }

# Root check
if [ "$EUID" -ne 0 ]; then
    error "Please run as root (use sudo)."
fi

# Ensure non-interactive mode
export DEBIAN_FRONTEND=noninteractive

# 1. Install dependencies if not present
log "Ensuring dependencies (live-build, debootstrap, curl) are installed..."
apt-get update -qq
apt-get install -y -qq live-build debootstrap curl

# 2. Initialize workspace
log "Initializing live-build configuration..."
lb clean --all

# Configuration for Debian 13 (Trixie)
lb config \
    --mode debian \
    --system live \
    --distribution trixie \
    --parent-distribution trixie \
    --archive-areas "main contrib non-free non-free-firmware" \
    --mirror-bootstrap "http://deb.debian.org/debian/" \
    --mirror-binary "http://deb.debian.org/debian/" \
    --parent-mirror-bootstrap "http://deb.debian.org/debian/" \
    --parent-mirror-binary "http://deb.debian.org/debian/" \
    --security false \
    --linux-packages "linux-image-amd64" \
    --bootloader "grub-efi" \
    --apt-recommends false \
    --debian-installer live \
    --memtest none \
    --source false

# 3. Trigger build
log "Starting the build process. This may take 20-45 minutes..."
lb build

# Find the generated ISO (standard name is usually live-image-amd64.hybrid.iso)
GENERATED_ISO=$(ls *.iso 2>/dev/null | head -n 1)

if [ -n "$GENERATED_ISO" ]; then
    if [ "$GENERATED_ISO" != "nexos-v1-amd64.iso" ]; then
        mv "$GENERATED_ISO" nexos-v1-amd64.iso
    fi
    log "${GREEN}Build successful! ISO generated: nexos-v1-amd64.iso${NC}"
else
    error "ISO was not generated. Check logs above for specific errors."
fi
