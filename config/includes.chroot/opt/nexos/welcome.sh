#!/bin/bash
# ============================================================
#  NexOS — Welcome Script (First Boot)
#  /opt/nexos/welcome.sh
# ============================================================

# Only show once
FLAG="$HOME/.config/nexos-welcomed"
if [[ -f "$FLAG" ]]; then
    exit 0
fi

# Use kdialog for KDE Plasma
if command -v kdialog &>/dev/null; then
    kdialog --title "⚡ Bienvenido a NexOS" --msgbox \
"¡Bienvenido a NexOS Vanguard Edition!
Tu sistema operativo seguro, privado y listo para todo.

🔒 Seguridad activa:
  • Firewall UFW (pre-configurado, puertos esenciales)
  • Fail2ban (protección anti-fuerza bruta)
  • AppArmor (control de acceso obligatorio)
  • Suricata IDS (detección de intrusiones en red)
  • USBGuard (control de dispositivos USB)
  • ClamAV (antimalware con escaneo diario)
  • AIDE (detección de integridad de archivos)
  • Kernel hardening (ASLR, anti-SYN flood)

🕵️ Privacidad activa:
  • DNS-over-HTTPS (dnscrypt-proxy)
  • MAC aleatorio en cada conexión WiFi
  • Firefox hardenizado (anti-tracking)
  • Proxychains4 + Tor + I2P disponibles
  • Firejail para sandboxing de apps
  • KeePassXC como gestor de contraseñas

🖥️ Servidor (desactivados por defecto):
  • SSH, Nginx, Apache, Docker, PostgreSQL, Redis, MariaDB
  • Actívalos con: sudo nexos-harden

🛠️ Herramientas disponibles:
  • nexos-harden  — Asistente de seguridad interactivo
  • nexos-clean   — Limpieza y privacidad
  • nexos-netmon  — Monitor de red en tiempo real

⚡ Pentesting: Nmap, Metasploit, Wireshark, Hashcat, Hydra,
   SQLMap, Aircrack-ng, Bettercap, y 100+ herramientas más.

📊 Auditoría: Ejecuta 'sudo lynis audit system'." 2>/dev/null
elif command -v zenity &>/dev/null; then
    zenity --info --title="⚡ NexOS" --width=500 \
        --text="Bienvenido a NexOS. Ejecuta 'sudo nexos-harden' para configurar tu sistema." 2>/dev/null
fi

mkdir -p "$(dirname "$FLAG")"
touch "$FLAG"
