# Registro de Cambios (Changelog) - NexOS

Todos los cambios notables en este proyecto serán documentados en este archivo siguiendo los estándares de [Keep a Changelog](https://keepachangelog.com/es-ES/1.0.0/).

## [2.9] - 2026-04-11
### Añadido
- **Identidad Visual**: Nuevo Logo y Banner profesionales.
- **Gobernanza**: Plantillas de Issues, Política de Seguridad y Código de Conducta.
- **Documentación**: ROADMAP.md, CONTRIBUTING.md, CHANGELOG.md y Wiki completa.
- **Limpieza Agresiva**: Gancho `99-cleanup.chroot` para reducir el tamaño de la ISO.
### Cambiado
- **Optimización de Tamaño**: Versión "Ultra Diet" eliminando Chromium y LibreOffice para satisfacer el límite de 2GB de GitHub.
- **Compresión**: Activada compresión XZ extrema en SquashFS.
- **README 2.0**: Rediseño total con enfoque profesional.

## [2.4] - 2026-04-11
### Añadido
- Soporte inicial para GitHub Releases automáticas.
- Compresión XZ activada (estándar).

## [2.0] - 2026-04-11
### Añadido
- Entorno de compilación migrado a **Docker (debian:trixie)**.
- Mejora en la persistencia de usuarios y servicios.

## [1.0] - 2026-04-10
### Añadido
- Versión inicial del proyecto funcional para Debian 13.
- Selección básica de herramientas de pentesting.
- Entorno KDE Plasma por defecto.

---
El formato se basa en [Keep a Changelog](https://keepachangelog.com/es-ES/1.0.0/).
