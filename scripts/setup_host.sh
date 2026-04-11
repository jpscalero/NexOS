#!/bin/bash
# NexOS Host Setup Script
# Este script prepara tu sistema local para compilar NexOS.

set -e

# Colores
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

log() { echo -e "${BLUE}[NexOS-Setup]${NC} $1"; }
warn() { echo -e "${YELLOW}[ADVERTENCIA]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }

# 1. Comprobación de Root
if [ "$EUID" -ne 0 ]; then
    error "Por favor, ejecuta este script como root (sudo ./scripts/setup_host.sh)"
fi

log "Iniciando configuración del entorno para NexOS..."

# 2. Comprobación de Recursos (Hardware)
log "Verificando recursos del sistema..."

# Espacio en disco (20 GB mínimo)
FREE_DISK=$(df -BG . | awk 'NR==2 {print $4}' | sed 's/G//')
if [ "$FREE_DISK" -lt 20 ]; then
    warn "Tienes menos de 20GB disponibles ($FREE_DISK GB). La compilación podría fallar."
else
    log "Espacio en disco OK: $FREE_DISK GB libres."
fi

# RAM (4 GB mínimo recomendado)
TOTAL_RAM=$(free -g | awk '/^Mem:/{print $2}')
if [ "$TOTAL_RAM" -lt 4 ]; then
    warn "Tienes menos de 4GB de RAM ($TOTAL_RAM GB). La compilación será lenta."
else
    log "Memoria RAM OK: $TOTAL_RAM GB."
fi

# 3. Instalación de Dependencias
log "Instalando dependencias necesarias..."
apt-get update -qq
apt-get install -y -qq live-build debootstrap curl git dos2unix xz-utils

# 4. Configurar Permisos
log "Configurando permisos de ejecución para los scripts de NexOS..."
chmod +x build_nexos.sh
chmod +x verify_integrity.sh
chmod +x config/hooks/live/*.chroot 2>/dev/null || true

# 5. Normalizar finales de línea (por si se descargó en Windows)
log "Normalizando finales de línea (LF)..."
find . -type f -name "*.sh" -exec dos2unix {} + 2>/dev/null
find . -type f -name "*.chroot" -exec dos2unix {} + 2>/dev/null

log "${GREEN}¡Configuración completada con éxito!${NC}"
log "Ahora puedes lanzar la compilación con: ${GREEN}sudo ./build_nexos.sh${NC}"
