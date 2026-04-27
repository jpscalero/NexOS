#!/bin/bash
# ============================================================
#  NexOS — Cleanup & Privacy Script
#  /opt/nexos/cleanup.sh
#  Symlinked to /usr/local/bin/nexos-clean
# ============================================================
set -euo pipefail

GREEN='\033[0;32m'
CYAN='\033[0;36m'
NC='\033[0m'

log() { echo -e "${GREEN}[✅]${NC} $1"; }

echo -e "${CYAN}"
echo "  ╔══════════════════════════════════════════════╗"
echo "  ║       🧹  NexOS — Limpieza y Privacidad     ║"
echo "  ╚══════════════════════════════════════════════╝"
echo -e "${NC}"

# Clean package cache
echo "Limpiando caché de paquetes..."
apt-get clean 2>/dev/null || true
apt-get autoclean 2>/dev/null || true
log "Caché de APT limpia."

# Clean thumbnail cache
REAL_USER="${SUDO_USER:-$USER}"
REAL_HOME=$(eval echo "~$REAL_USER")

rm -rf "$REAL_HOME/.cache/thumbnails/"* 2>/dev/null || true
log "Miniaturas eliminadas."

# Clean recently used files list
rm -f "$REAL_HOME/.local/share/recently-used.xbel" 2>/dev/null || true
log "Historial de archivos recientes limpio."

# Clean bash & zsh history
rm -f "$REAL_HOME/.bash_history" 2>/dev/null || true
rm -f "$REAL_HOME/.zsh_history" 2>/dev/null || true
history -c 2>/dev/null || true
log "Historial de shells limpio."

# Clean KDE recent documents
rm -rf "$REAL_HOME/.local/share/RecentDocuments/"* 2>/dev/null || true
log "Documentos recientes de KDE limpios."

# Clean KDE activity data
rm -rf "$REAL_HOME/.local/share/kactivitymanagerd/"* 2>/dev/null || true
log "Actividad de KDE limpia."

# Clean Firefox data
rm -rf "$REAL_HOME/.mozilla/firefox/*/cookies.sqlite" 2>/dev/null || true
rm -rf "$REAL_HOME/.mozilla/firefox/*/formhistory.sqlite" 2>/dev/null || true
log "Cookies y formularios de Firefox limpios."

# Clean temporary files
rm -rf /tmp/* 2>/dev/null || true
rm -rf /var/tmp/* 2>/dev/null || true
log "Archivos temporales eliminados."

# Clean system logs (keep last 3 days)
journalctl --vacuum-time=3d 2>/dev/null || true
log "Logs del sistema reducidos a 3 días."

# Secure delete swap
swapoff -a 2>/dev/null || true
swapon -a 2>/dev/null || true
log "Swap purgada."

# Run BleachBit if available
if command -v bleachbit &>/dev/null; then
    bleachbit --clean system.tmp system.trash system.cache 2>/dev/null || true
    log "BleachBit ejecutado."
fi

# Run mat2 on common directories if available
if command -v mat2 &>/dev/null; then
    echo "Puedes limpiar metadatos de archivos con: mat2 --inplace <archivo>"
    log "mat2 disponible para limpieza de metadatos."
fi

echo ""
echo -e "${GREEN}╔══════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║  ✅  Limpieza completada. Sistema limpio.    ║${NC}"
echo -e "${GREEN}╚══════════════════════════════════════════════╝${NC}"
