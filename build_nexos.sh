#!/bin/bash
# ============================================================
#  NexOS — Build Script
#  Orchestrates ISO creation using live-build.
#  Configuration delegated to auto/config (Kali-style).
# ============================================================

set -e

# Colors
BOLD='\033[1m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

banner() {
    echo -e "${CYAN}"
    echo "  ╔══════════════════════════════════════════╗"
    echo "  ║          ⚡  NexOS  Builder  ⚡           ║"
    echo "  ║     Debian 13 (Trixie) Custom Distro     ║"
    echo "  ║   Pentesting · Security · Privacy · Dev  ║"
    echo "  ╚══════════════════════════════════════════╝"
    echo -e "${NC}"
}

log() { echo -e "${BLUE}[NexOS]${NC} $1"; }
warn() { echo -e "${YELLOW}[AVISO]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }

banner

# Root check
if [ "$EUID" -ne 0 ]; then
    error "Por favor, ejecuta como root (usa sudo)."
fi

# Non-interactive mode
export DEBIAN_FRONTEND=noninteractive

# 1. Install build dependencies
log "Asegurando dependencias de compilación..."
apt-get update -qq
apt-get install -y -qq \
    live-build debootstrap curl \
    isolinux syslinux-common syslinux-efi \
    xorriso dos2unix \
    plymouth plymouth-themes \
    squashfs-tools coreutils sudo

# 2. Normalize line endings (critical when building from Windows clones)
log "Normalizando finales de línea..."
find . -type f \( -name "*.sh" -o -name "*.chroot" -o -name "*.conf" -o -name "*.toml" \) -exec dos2unix {} + 2>/dev/null || true
find ./auto -type f -exec dos2unix {} + 2>/dev/null || true

# 3. Ensure auto scripts and hooks are executable
chmod +x auto/config auto/build auto/clean 2>/dev/null || true
chmod +x config/hooks/live/*.chroot 2>/dev/null || true
find config/includes.chroot -type f -name "*.sh" -exec chmod +x {} + 2>/dev/null || true

# 4. Clean previous build
log "Limpiando estado de compilación anterior..."
lb clean --all 2>/dev/null || true

# 5. Run lb config via auto/config
log "Configurando live-build (vía auto/config)..."
lb config

# 6. Build
log "Iniciando el proceso de compilación. Esto puede tardar 30-60 minutos..."
lb build 2>&1 | tee build.log

# 7. Find and rename generated ISO
GENERATED_ISO=$(ls *.iso 2>/dev/null | head -n 1)

if [ -n "$GENERATED_ISO" ]; then
    FINAL_NAME="nexos-v1-amd64.iso"
    if [ "$GENERATED_ISO" != "$FINAL_NAME" ]; then
        mv "$GENERATED_ISO" "$FINAL_NAME"
    fi

    # Generate checksums
    log "Generando checksums..."
    sha256sum "$FINAL_NAME" > "${FINAL_NAME}.sha256"
    md5sum "$FINAL_NAME" > "${FINAL_NAME}.md5"

    ISO_SIZE=$(du -h "$FINAL_NAME" | cut -f1)

    echo ""
    echo -e "${GREEN}╔══════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║  ✅  ISO GENERADA CON ÉXITO              ║${NC}"
    echo -e "${GREEN}╠══════════════════════════════════════════╣${NC}"
    echo -e "${GREEN}║  Archivo: ${BOLD}$FINAL_NAME${NC}"
    echo -e "${GREEN}║  Tamaño:  ${BOLD}$ISO_SIZE${NC}"
    echo -e "${GREEN}║  SHA256:  $(head -c 16 ${FINAL_NAME}.sha256)...${NC}"
    echo -e "${GREEN}╚══════════════════════════════════════════╝${NC}"
else
    error "La ISO no fue generada. Revisa build.log para errores específicos."
fi
