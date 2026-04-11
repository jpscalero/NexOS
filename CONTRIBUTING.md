# Guía de Contribución para NexOS

¡Gracias por tu interés en mejorar NexOS! Este es un proyecto de código abierto y agradecemos cualquier tipo de colaboración.

## 🚀 Cómo contribuir

### 1. Reportar Errores
Si encuentras un error o algo no funciona como debería, por favor abre un **Issue** en GitHub describiendo:
- El problema detallado.
- Pasos para reproducirlo.
- Tu entorno (si estás usando QEMU, VirtualBox, etc.).

### 2. Sugerir Mejoras
¿Tienes una idea para una nueva herramienta o una configuración mejor? Abre una **Propuesta de Mejora (Feature Request)** en la sección de Issues.

### 3. Enviar Cambios (Pull Requests)
Si quieres modificar el código directamente:
1. Haz un **Fork** del repositorio.
2. Crea una rama para tu mejora (`git checkout -b mejora/mi-nueva-caracteristica`).
3. Realiza tus cambios y haz commit (`git commit -m 'Añadida nueva herramienta X'`).
4. Haz push a tu rama (`git push origin mejora/mi-nueva-caracteristica`).
5. Abre un **Pull Request** hacia la rama `main` del repositorio original.

## 🛠️ Requisitos Técnicos
- Los scripts deben ser compatibles con **Debian 13 (Trixie)**.
- Asegúrate de que los scripts no sean interactivos (usa `-y` en los comandos de instalación).
- No subas archivos binarios grandes (ISOs, imágenes de disco) al repositorio.

## ⚖️ Código de Conducta
Sé respetuoso y constructivo. Estamos aquí para aprender y crear una herramienta útil para la comunidad de seguridad.

---
Al contribuir, aceptas que tus cambios estarán bajo la licencia **GPLv3**.
