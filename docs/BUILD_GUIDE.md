# NexOS Build Guide

Esta guía explica cómo compilar tu propia versión de NexOS desde cero.

## 📋 Requisitos Previos

- **Sistema Operativo**: Debian 13 (Trixie) o Ubuntu 22.04+ (preferiblemente vía WSL2 si estás en Windows).
- **Herramientas**: `live-build`, `debootstrap`, `curl`, `xorriso`.
- **Privilegios**: Debes ejecutar los comandos como `root` o con `sudo`.

## 🛠️ Pasos de Compilación

1.  **Instalar dependencias**:
    ```bash
    sudo apt update
    sudo apt install -y live-build debootstrap curl isolinux xorriso
    ```

2.  **Verificar integridad**:
    Antes de compilar, asegúrate de que todos los archivos de configuración están presentes:
    ```bash
    ./verify_integrity.sh
    ```

3.  **Compilar**:
    Ejecuta el script principal de construcción:
    ```bash
    sudo ./build_nexos.sh
    ```

4.  **Resultado**:
    Al finalizar (20-40 min), obtendrás un archivo llamado `nexos-v1-amd64.iso` en la carpeta raíz.

## ⚠️ Notas Importantes
- Asegúrate de tener al menos **15GB de espacio libre** en disco.
- No interrumpas el proceso `lb build`, ya que puede dejar montajes huérfanos. Si ocurre, usa `sudo lb clean` antes de reintentar.
