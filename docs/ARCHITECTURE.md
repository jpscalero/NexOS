# NexOS Architecture Overview

NexOS is a modular, Debian-based Linux distribution designed for security professionals. It follows a layered approach to ensure stability and reproducibility.

## 🏗️ Layer Structure

1.  **Base Layer (Debian 13 "Trixie")**: Provides the core system, kernel, and package management (APT).
2.  **Orchestration Layer (Live-Build)**: Uses the official Debian `live-build` framework to configure the live environment, bootloaders, and ISO generation.
3.  **Customization Layer (Hooks & Config)**:
    *   `config/hooks/live/*.chroot`: Scripts that run inside the system during the build to install tools, configure services, and apply branding.
    *   `config/includes.chroot/`: Overlay of files that are copied directly into the system's root (e.g., configurations in `/etc/skel`).
4.  **Desktop Layer (KDE Plasma)**: A customized desktop environment tuned for performance and "Premium" aesthetics.

## 🔄 Building Process

- **Preparation**: `build_nexos.sh` initializes the workspace.
- **Verification**: `verify_integrity.sh` audits the configuration.
- **Assembly**: `lb build` compiles everything into a bootable ISO.
