#!/bin/bash
# Script de Verificación de Integridad NexOS v3.0 (XFCE Minimalista)
# Este script comprueba el entorno de compilación y archivos de configuración.

set -e

# Colores
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
        echo -e "[${RED}FALTA${NC}] $1"
        ERRORS=$((ERRORS + 1))
    fi
}

echo "============================================"
echo "  Verificación de Integridad NexOS (XFCE)"
echo "============================================"
echo ""

# 1. Scripts Principales
echo "--- Scripts Principales de Compilación ---"
check_file "build_nexos.sh"
check_file "verify_integrity.sh"

# 2. Scripts Auto
echo ""
echo "--- Scripts Auto (estilo Kali) ---"
check_file "auto/config"
check_file "auto/build"
check_file "auto/clean"

# 3. Listas de Paquetes
echo ""
echo "--- Listas de Paquetes ---"
for list in desktop tools server pentesting privacy; do
    check_file "config/package-lists/${list}.list.chroot"
done

# 4. Hooks de Compilación (XFCE y Privacidad)
echo ""
echo "--- Hooks de Compilación ---"
check_file "config/hooks/live/03-db-setup.chroot"
check_file "config/hooks/live/04-wallpaper.chroot"
check_file "config/hooks/live/05-self-destruct.chroot"

# 5. Componentes de Privacidad y Base de Datos
echo ""
echo "--- Componentes del Sistema ---"
check_file "config/includes.chroot/usr/local/sbin/self-destruct.sh"
check_file "config/includes.chroot/etc/systemd/system/self-destruct.service"
check_file "config/includes.chroot/opt/nexos/sql/optimize_audit.sql"

# 6. Dashboard
echo ""
echo "--- Dashboard Web ---"
check_file "config/includes.chroot/opt/nexos/dashboard/index.html"
check_file "config/includes.chroot/opt/nexos/dashboard/update-status.sh"
check_file "config/includes.chroot/etc/cron.d/nexos-dashboard"

# 7. Verificación de Sintaxis de Scripts Shell
echo ""
echo "--- Verificación de Sintaxis de Scripts ---"
for script in build_nexos.sh verify_integrity.sh auto/config auto/build auto/clean config/hooks/live/*.chroot; do
    if [ -f "$script" ]; then
        if bash -n "$script" 2>/dev/null; then
            echo -e "[${GREEN}OK${NC}] Sintaxis: $script"
        else
            echo -e "[${RED}FALLO${NC}] Error de sintaxis: $script"
            ERRORS=$((ERRORS + 1))
        fi
    fi
done

# 8. Resumen Final
echo ""
echo "============================================"
if [ $ERRORS -eq 0 ]; then
    echo -e "  ${GREEN}✅ ¡Todas las verificaciones pasaron! Listo para compilar.${NC}"
else
    echo -e "  ${RED}❌ $ERRORS problema(s) encontrado(s). Corregir antes de compilar.${NC}"
fi
echo "============================================"

if [ $ERRORS -gt 0 ]; then
    exit 1
fi
