# NexOS - Custom Debian Distribution

NexOS is a custom Debian 13 (Trixie) distribution featuring KDE Plasma, server services, and a pre-configured suite of pentesting tools.

## 🚀 Two Ways to Build NexOS

### 1. Build Automatically on GitHub (Recommended)
You can compile the ISO directly on GitHub:

1. **Push to GitHub**: Upload this folder to your repository.
2. **Standard Build**: Every time you push to `main`, an ISO is generated as a temporary artifact (stored for 7 days).
3. **Permanent Version**: To create a permanent version, create a **Tag** (e.g., `v1.0`).
   ```bash
   git tag v1.0
   git push origin v1.0
   ```
   This will automatically create a **GitHub Release** with the ISO attached permanently.

### 2. Build Locally (Debian/Ubuntu)
If you prefer building locally, ensure you have at least 20GB of free space.

1. **Permissions**:
   ```bash
   chmod +x build_nexos.sh verify_integrity.sh config/hooks/live/*.chroot
   ```
2. **Verify Integrity**:
   ```bash
   ./verify_integrity.sh
   ```
3. **Generate ISO**:
   ```bash
   sudo ./build_nexos.sh
   ```

## 🛠 Features
- **Desktop**: KDE Plasma (Customized)
- **Security**: Nmap, Metasploit, Wireshark, John the Ripper, Sqlmap, etc.
- **Services**: SSH, Nginx, MariaDB (Pre-configured).
- **Base**: Debian 13 "Trixie" (Testing).

## 🔑 Default Credentials
- **User**: `nexos`
- **Password**: `nexos`
- **Root Password**: `nexos`
- **Hostname**: `nexos`

## 🧪 Testing the ISO
Use QEMU for a quick test:
```bash
sudo apt install qemu-system-x86
qemu-system-x86_64 -enable-kvm -m 2G -cdrom nexos-v1-amd64.iso
```
