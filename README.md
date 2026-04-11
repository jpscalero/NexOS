# 🚀 NexOS - Distribución Debian Personalizada

[![Build NexOS ISO](https://github.com/jpscalero/NexOS/actions/workflows/build_nexos.yml/badge.svg)](https://github.com/jpscalero/NexOS/actions/workflows/build_nexos.yml)
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![Debian Version](https://img.shields.io/badge/Debian-13__Trixie-red.svg)](https://www.debian.org/releases/trixie/)

NexOS es una distribución personalizada basada en **Debian 13 (Trixie)** diseñada para seguridad, administración de servidores y aprendizaje experimental. Incluye el entorno de escritorio **KDE Plasma**, servicios de servidor pre-configurados y una suite completa de herramientas de **Pentesting**.

---

## 📖 Documentación Detallada (Wiki)
Para guías completas, manuales de usuario y listas de herramientas, visita nuestra **[Wiki Oficial](https://github.com/jpscalero/NexOS/wiki)**.

---

## 🛠️ Cómo Compilar NexOS

### 1. Compilación en la Nube (Recomendado)
Puedes generar la ISO directamente en GitHub sin instalar nada en tu PC:

1. **Sube los archivos** a tu propio repositorio de GitHub.
2. **Compilación Estándar**: Cada vez que hagas un `push` a la rama `main`, se generará una ISO temporal (disponible por 7 días en la pestaña **Actions**).
3. **Versión Permanente (Release)**: Crea una etiqueta (Tag) para guardar una versión para siempre:
   ```bash
   git tag v1.0
   git push origin v1.0
   ```
   Esto creará automáticamente una **GitHub Release** con la ISO adjunta de forma permanente.

### 2. Compilación Local (Debian/Ubuntu)
Si prefieres compilar en tu propia máquina, asegúrate de tener al menos 20GB de espacio libre.

1. **Instalar dependencias y dar permisos**:
   ```bash
   chmod +x build_nexos.sh verify_integrity.sh config/hooks/live/*.chroot
   ```
2. **Generar ISO**:
   ```bash
   sudo ./build_nexos.sh
   ```

---

## ✨ Características Principales
- **Escritorio**: KDE Plasma (Personalizado y ligero).
- **Seguridad**: Nmap, Metasploit, Wireshark, John the Ripper, Sqlmap, etc.
- **Servidores**: SSH, Nginx, MariaDB (Pre-instalados y listos para activar).
- **Base**: Debian 13 "Trixie" (Testing) para tener software moderno.

## 🔑 Credenciales por Defecto
- **Usuario**: `nexos`
- **Contraseña**: `nexos`
- **Contraseña de Root**: `nexos`
- **Hostname**: `nexos`

---

## 🧪 Probar la ISO con QEMU
Si ya tienes la ISO y quieres probarla rápidamente sin instalar:
```bash
qemu-system-x86_64 -enable-kvm -m 2G -cdrom nexos-v1-amd64.iso
```

---

## 🤝 Contribuir
¿Quieres añadir herramientas o mejoras? Revisa nuestra **[Guía de Contribución](CONTRIBUTING.md)**.

## ⚖️ Licencia
Este proyecto está bajo la licencia **GPLv3**. Consulta el archivo [LICENSE](LICENSE) para más detalles.
