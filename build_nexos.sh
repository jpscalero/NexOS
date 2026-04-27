#!/bin/bash
# Script de Compilación de NexOS
# Este script orquesta la creación de la ISO de NexOS usando live-build.
# La configuración se delega a auto/config (estilo Kali).

set -e

# Colores para los logs
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

log() { echo -e "${BLUE}[NexOS]${NC} $1"; }
warn() { echo -e "${YELLOW}[AVISO]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }

# Verificación de root
if [ "$EUID" -ne 0 ]; then
    error "Por favor, ejecuta como root (usa sudo)."
fi

# Asegurar modo no interactivo
export DEBIAN_FRONTEND=noninteractive

# 1. Instalar dependencias si no están presentes
log "Asegurando que las dependencias de compilación estén instaladas..."
apt-get update -qq
apt-get install -y -qq \
    live-build debootstrap curl \
    isolinux syslinux-common syslinux-efi \
    xorriso dos2unix

# 2. Normalizar finales de línea (crítico al compilar desde repos clonados en Windows)
log "Normalizando finales de línea..."
find . -type f \( -name "*.sh" -o -name "*.chroot" -o -name "*.conf" \) -exec dos2unix {} + 2>/dev/null || true
find ./auto -type f -exec dos2unix {} + 2>/dev/null || true

# 3. Asegurar que los scripts auto sean ejecutables
chmod +x auto/config auto/build auto/clean 2>/dev/null || true
chmod +x config/hooks/live/*.chroot 2>/dev/null || true

# 4. Limpiar compilación anterior
log "Limpiando estado de compilación anterior..."
lb clean --all 2>/dev/null || true

# 5. Ejecutar lb config vía auto/config
log "Configurando live-build (vía auto/config)..."
lb config

# 6. Ejecutar la compilación
log "Iniciando el proceso de compilación. Esto puede tardar 20-45 minutos..."
lb build 2>&1 | tee build.log

# 7. Buscar y renombrar la ISO generada
GENERATED_ISO=$(ls *.iso 2>/dev/null | head -n 1)

if [ -n "$GENERATED_ISO" ]; then
    FINAL_NAME="nexos-v1-amd64.iso"
    if [ "$GENERATED_ISO" != "$FINAL_NAME" ]; then
        mv "$GENERATED_ISO" "$FINAL_NAME"
    fi

    # Generar checksums
    log "Generando checksums..."
    sha256sum "$FINAL_NAME" > "${FINAL_NAME}.sha256"
    md5sum "$FINAL_NAME" > "${FINAL_NAME}.md5"

    ISO_SIZE=$(du -h "$FINAL_NAME" | cut -f1)
    log "${GREEN}¡Compilación exitosa!${NC}"
    log "  ISO: $FINAL_NAME ($ISO_SIZE)"
    log "  SHA256: $(cat ${FINAL_NAME}.sha256)"
else
    error "La ISO no fue generada. Revisa build.log para errores específicos."
fi
