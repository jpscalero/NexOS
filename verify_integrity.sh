#!/bin/bash
# Script de Verificación de Integridad NexOS v3.0
# Este script comprueba el entorno de compilación y archivos de configuración.
# Ejecutar antes de cada compilación para asegurar que todos los assets requeridos estén presentes.

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

check_optional() {
    if [ -f "$1" ]; then
        echo -e "[${GREEN}OK${NC}] $1"
    else
        echo -e "[${YELLOW}OPCIONAL${NC}] $1"
        WARNINGS=$((WARNINGS + 1))
    fi
}

echo "============================================"
echo "  Verificación de Integridad NexOS v3.0"
echo "============================================"
echo ""

# 1. Scripts Principales de Compilación
echo "--- Scripts Principales de Compilación ---"
check_file "build_nexos.sh"
check_file "verify_integrity.sh"

# 2. Scripts Auto (estilo Kali)
echo ""
echo "--- Scripts Auto (estilo Kali) ---"
check_file "auto/config"
check_file "auto/build"
check_file "auto/clean"

# 3. Listas de Paquetes
echo ""
echo "--- Listas de Paquetes ---"
for list in desktop tools server pentesting; do
    check_file "config/package-lists/${list}.list.chroot"
done

# 4. Hooks de Compilación
echo ""
echo "--- Hooks de Compilación ---"
for hook in 00-system-branding 01-metasploit 02-user-setup 03-service-config \
            04-kde-custom 05-premium-ui 06-remove-debian-branding \
            07-calamares-config 08-live-config-fixups \
            10-force-nexos-branding 99-cleanup; do
    check_file "config/hooks/live/${hook}.chroot"
done

# 5. Assets Visuales y Marca
echo ""
echo "--- Assets Visuales y Marca ---"
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

# Fondos de Pantalla y Logos
check_file "config/includes.chroot/usr/share/pixmaps/nexos-logo.png"
check_file "config/includes.chroot/usr/share/wallpapers/nexos/wallpaper.png"

# 6. Configuración de Arranque
echo ""
echo "--- Configuración de Arranque ---"
check_file "config/includes.binary/boot/grub/grub.cfg"
check_file "config/includes.binary/boot/grub/splash.png"
check_file "config/includes.binary/isolinux/isolinux.cfg"
check_file "config/includes.binary/isolinux/splash.png"

# 7. Configuración del Sistema
echo ""
echo "--- Configuración del Sistema ---"
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

# 9. Entorno de Usuario (Esqueleto)
echo ""
echo "--- Entorno de Usuario (Esqueleto) ---"
check_file "config/includes.chroot/etc/skel/.bashrc"
check_file "config/includes.chroot/etc/skel/.bash_profile"
check_file "config/includes.chroot/etc/skel/.config/kdeglobals"
check_file "config/includes.chroot/etc/skel/.config/konsolerc"
check_file "config/includes.chroot/etc/skel/.config/plasmarc"
check_file "config/includes.chroot/etc/skel/.config/plasma-org.kde.plasma.desktop-appletsrc"
check_file "config/includes.chroot/etc/skel/.local/share/konsole/NexOS.profile"

# 10. Gobernanza y Documentación
echo ""
echo "--- Gobernanza y Documentación ---"
for doc in README.md LICENSE SECURITY.md ROADMAP.md CREDITS.md CONTRIBUTING.md CODE_OF_CONDUCT.md CHANGELOG.md; do
    check_file "$doc"
done
check_file "docs/ARCHITECTURE.md"
check_file "docs/BUILD_GUIDE.md"

# 11. Verificación de Sintaxis de Scripts Shell
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

# 12. Verificaciones de Consistencia
echo ""
echo "--- Verificaciones de Consistencia ---"

# Comprobar que el nombre del tema Plymouth coincide con plymouthd.conf
if [ -f "config/includes.chroot/etc/plymouth/plymouthd.conf" ]; then
    PLYMOUTH_THEME=$(grep "^Theme=" config/includes.chroot/etc/plymouth/plymouthd.conf | cut -d= -f2)
    if [ -d "config/includes.chroot/usr/share/plymouth/themes/$PLYMOUTH_THEME" ]; then
        echo -e "[${GREEN}OK${NC}] Directorio del tema Plymouth '$PLYMOUTH_THEME' existe"
    else
        echo -e "[${RED}FALLO${NC}] Directorio del tema Plymouth '$PLYMOUTH_THEME' falta"
        ERRORS=$((ERRORS + 1))
    fi
fi

# Comprobar que el perfil de Konsole existe
if [ -f "config/includes.chroot/etc/skel/.config/konsolerc" ]; then
    KONSOLE_PROFILE=$(grep "^DefaultProfile=" config/includes.chroot/etc/skel/.config/konsolerc | cut -d= -f2)
    PROFILE_PATH="config/includes.chroot/etc/skel/.local/share/konsole/$KONSOLE_PROFILE"
    if [ -f "$PROFILE_PATH" ]; then
        echo -e "[${GREEN}OK${NC}] Perfil de Konsole '$KONSOLE_PROFILE' existe"
    else
        echo -e "[${RED}FALLO${NC}] Perfil de Konsole '$KONSOLE_PROFILE' falta en $PROFILE_PATH"
        ERRORS=$((ERRORS + 1))
    fi
fi

# 13. Resumen Final
echo ""
echo "============================================"
if [ $ERRORS -eq 0 ]; then
    if [ $WARNINGS -gt 0 ]; then
        echo -e "  ${GREEN}✅ ¡Todas las verificaciones pasaron!${NC} ($WARNINGS avisos opcionales)"
    else
        echo -e "  ${GREEN}✅ ¡Todas las verificaciones pasaron! Listo para compilar.${NC}"
    fi
else
    echo -e "  ${RED}❌ $ERRORS problema(s) encontrado(s). Corregir antes de compilar.${NC}"
fi
echo "============================================"

# Salir con error si se encontraron problemas (fallará en CI)
if [ $ERRORS -gt 0 ]; then
    exit 1
fi
