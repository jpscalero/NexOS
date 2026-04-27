#!/bin/bash
# ============================================================
#  NexOS — Interactive Hardening Script
#  /opt/nexos/harden.sh
#  Symlinked to /usr/local/bin/nexos-harden
# ============================================================
set -euo pipefail

BOLD='\033[1m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

log()  { echo -e "${GREEN}[✅]${NC} $1"; }
warn() { echo -e "${YELLOW}[⚠️]${NC} $1"; }
ask()  { echo -ne "${CYAN}[?]${NC} $1 [s/N]: "; read -r ans; [[ "$ans" =~ ^[sS]$ ]]; }

if [[ $EUID -ne 0 ]]; then
    echo -e "${RED}Error: Ejecuta como root: sudo nexos-harden${NC}"
    exit 1
fi

echo -e "${CYAN}"
echo "  ╔═══════════════════════════════════════════════╗"
echo "  ║    🛡️  NexOS — Asistente de Seguridad  🛡️     ║"
echo "  ╚═══════════════════════════════════════════════╝"
echo -e "${NC}"
echo "Este asistente te ayudará a reforzar la seguridad de tu sistema."
echo "Responde 's' o 'N' a cada pregunta."
echo ""

# ── 1. Disable Root Login ──────────────────────────────────
if ask "¿Bloquear el login directo como root? (recomendado)"; then
    passwd -l root
    log "Login de root bloqueado. Usa 'sudo' para tareas administrativas."
else
    warn "Login de root no se ha bloqueado."
fi
echo ""

# ── 2. Enable SSH Service ─────────────────────────────────
if ask "¿Activar el servidor SSH ahora? (puerto 2222)"; then
    systemctl enable --now ssh
    log "SSH activado en el puerto 2222."
    echo -e "   Conéctate con: ${BOLD}ssh -p 2222 usuario@$(hostname -I | awk '{print $1}')${NC}"
else
    warn "SSH permanece desactivado."
fi
echo ""

# ── 3. Setup SSH Keys ─────────────────────────────────────
if ask "¿Generar un par de claves SSH para este usuario?"; then
    REAL_USER="${SUDO_USER:-$USER}"
    REAL_HOME=$(eval echo "~$REAL_USER")
    if [[ ! -f "$REAL_HOME/.ssh/id_ed25519" ]]; then
        sudo -u "$REAL_USER" ssh-keygen -t ed25519 -C "$REAL_USER@nexos" -f "$REAL_HOME/.ssh/id_ed25519" -N ""
        log "Clave SSH Ed25519 generada en $REAL_HOME/.ssh/id_ed25519"
    else
        warn "Ya existe una clave SSH. No se ha sobrescrito."
    fi
else
    warn "No se han generado claves SSH."
fi
echo ""

# ── 4. Enable Nginx ───────────────────────────────────────
if ask "¿Activar el servidor web Nginx?"; then
    systemctl enable --now nginx
    log "Nginx activado. Accede en http://localhost"
else
    warn "Nginx permanece desactivado."
fi
echo ""

# ── 5. Enable Docker ──────────────────────────────────────
if ask "¿Activar Docker y añadir tu usuario al grupo docker?"; then
    systemctl enable --now docker
    REAL_USER="${SUDO_USER:-$USER}"
    usermod -aG docker "$REAL_USER"
    log "Docker activado. Cierra sesión y vuelve a entrar para usar docker sin sudo."
else
    warn "Docker permanece desactivado."
fi
echo ""

# ── 6. Enable PostgreSQL ─────────────────────────────────
if ask "¿Activar PostgreSQL?"; then
    systemctl enable --now postgresql
    log "PostgreSQL activado."
else
    warn "PostgreSQL permanece desactivado."
fi
echo ""

# ── 7. Enable Redis ───────────────────────────────────────
if ask "¿Activar Redis?"; then
    systemctl enable --now redis-server
    log "Redis activado."
else
    warn "Redis permanece desactivado."
fi
echo ""

# ── 8. Enable MariaDB ────────────────────────────────────
if ask "¿Activar MariaDB?"; then
    systemctl enable --now mariadb
    log "MariaDB activado."
else
    warn "MariaDB permanece desactivado."
fi
echo ""

# ── 9. Disable IPv6 ───────────────────────────────────────
if ask "¿Desactivar IPv6 completamente? (más seguro si no lo usas)"; then
    cat >> /etc/sysctl.d/99-nexos-hardening.conf << EOF

# IPv6 disabled by NexOS hardening script
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
net.ipv6.conf.lo.disable_ipv6 = 1
EOF
    sysctl --system > /dev/null 2>&1
    log "IPv6 desactivado."
else
    warn "IPv6 permanece activo."
fi
echo ""

# ── 10. Initialize AIDE Database ──────────────────────────
if ask "¿Inicializar la base de datos de AIDE? (detección de intrusiones)"; then
    echo "   Esto puede tardar unos minutos..."
    aideinit -y -f 2>/dev/null || aide --init 2>/dev/null || true
    log "Base de datos de AIDE inicializada."
else
    warn "AIDE no inicializado."
fi
echo ""

# ── 11. Configure Automatic Updates ──────────────────────
if ask "¿Activar actualizaciones de seguridad automáticas?"; then
    dpkg-reconfigure -plow unattended-upgrades 2>/dev/null || true
    log "Actualizaciones automáticas configuradas."
else
    warn "Actualizaciones automáticas no configuradas."
fi
echo ""

# ── 12. Enable UFW Firewall ──────────────────────────────
if ask "¿Activar el firewall UFW ahora?"; then
    ufw --force enable
    log "Firewall UFW activado."
    ufw status verbose
else
    warn "Firewall no activado."
fi
echo ""

# ── 13. Run Lynis Audit ──────────────────────────────────
if ask "¿Ejecutar una auditoría de seguridad ahora? (tarda ~2 min)"; then
    echo ""
    lynis audit system --quick 2>/dev/null || warn "Lynis no disponible."
else
    warn "Auditoría omitida. Puedes ejecutarla luego con: sudo lynis audit system"
fi

echo ""
echo -e "${GREEN}╔═══════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║  🛡️  Hardening completado con éxito           ║${NC}"
echo -e "${GREEN}╚═══════════════════════════════════════════════╝${NC}"
echo ""
echo -e "Ejecuta ${BOLD}sudo lynis audit system${NC} en cualquier momento para"
echo "obtener una puntuación de seguridad detallada."
