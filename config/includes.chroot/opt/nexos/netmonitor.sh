#!/bin/bash
# ============================================================
#  NexOS — Network Security Monitor
#  /opt/nexos/netmonitor.sh
#  Symlinked to /usr/local/bin/nexos-netmon
#  Real-time network security dashboard
# ============================================================

BOLD='\033[1m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

clear
echo -e "${CYAN}"
echo "  ╔══════════════════════════════════════════════════╗"
echo "  ║    📡  NexOS — Monitor de Red en Tiempo Real    ║"
echo "  ╚══════════════════════════════════════════════════╝"
echo -e "${NC}"

echo -e "${BOLD}═══ Interfaces de Red ═══${NC}"
ip -br addr show
echo ""

echo -e "${BOLD}═══ Conexiones Activas (Puertos Abiertos) ═══${NC}"
ss -tulnp 2>/dev/null | head -25
echo ""

echo -e "${BOLD}═══ Conexiones Establecidas ═══${NC}"
ss -tnp state established 2>/dev/null | head -25
echo ""

echo -e "${BOLD}═══ Tabla ARP ═══${NC}"
arp -n 2>/dev/null || ip neigh show
echo ""

echo -e "${BOLD}═══ Rutas ═══${NC}"
ip route show
echo ""

echo -e "${BOLD}═══ DNS Actual ═══${NC}"
cat /etc/resolv.conf | grep -v "^#"
echo ""

echo -e "${BOLD}═══ Firewall (UFW) ═══${NC}"
ufw status verbose 2>/dev/null || echo "UFW no disponible"
echo ""

echo -e "${BOLD}═══ AppArmor ═══${NC}"
aa-status 2>/dev/null | head -10 || echo "AppArmor no disponible"
echo ""

echo -e "${BOLD}═══ Fail2ban — IPs Baneadas ═══${NC}"
fail2ban-client status 2>/dev/null || echo "Fail2ban no disponible"

for jail in $(fail2ban-client status 2>/dev/null | grep "Jail list" | sed 's/.*://;s/,/ /g'); do
    echo -e "\n  ${YELLOW}Jail: $jail${NC}"
    fail2ban-client status "$jail" 2>/dev/null | grep "Banned IP"
done

echo ""
echo -e "${BOLD}═══ Suricata IDS ═══${NC}"
systemctl is-active suricata 2>/dev/null && echo -e "${GREEN}Suricata: ACTIVO${NC}" || echo -e "${RED}Suricata: INACTIVO${NC}"
if [ -f /var/log/suricata/fast.log ]; then
    echo "  Últimas alertas:"
    tail -5 /var/log/suricata/fast.log 2>/dev/null
fi

echo ""
echo -e "${BOLD}═══ USBGuard ═══${NC}"
usbguard list-devices 2>/dev/null | head -10 || echo "USBGuard no disponible"

echo ""
echo -e "${BOLD}═══ Tráfico de Red (vnstat) ═══${NC}"
vnstat -s 2>/dev/null || echo "vnstat no disponible"

echo ""
echo -e "${BOLD}═══ Conexiones Sospechosas ═══${NC}"
# Show connections to non-standard ports
ss -tnp state established 2>/dev/null | awk '$5 !~ /:80$|:443$|:22$|:53$|:2222$/' | head -10
echo ""

echo -e "${GREEN}Tip: Ejecuta 'sudo iftop' o 'sudo nethogs' para monitorización en vivo.${NC}"
echo -e "${GREEN}Tip: Ejecuta 'sudo bettercap' para análisis avanzado de red.${NC}"
