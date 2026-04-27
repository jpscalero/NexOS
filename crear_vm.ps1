# Script para crear VM NexOS en Hyper-V
# Ejecutar como Administrador

Write-Host "=== Creando VM NexOS ===" -ForegroundColor Cyan

# 1. Limpiar VM anterior
Write-Host "Limpiando VM anterior..."
Stop-VM -Name "nexos" -Force -ErrorAction SilentlyContinue
Remove-VM -Name "nexos" -Force -ErrorAction SilentlyContinue
Remove-Item "C:\ProgramData\Microsoft\Windows\Virtual Hard Disks\nexos.vhdx" -Force -ErrorAction SilentlyContinue
Start-Sleep -Seconds 2

# 2. Crear disco duro virtual
Write-Host "Creando disco virtual de 40GB..."
New-VHD -Path "C:\ProgramData\Microsoft\Windows\Virtual Hard Disks\nexos.vhdx" -SizeBytes 40GB -Dynamic | Out-Null
Write-Host "[OK] Disco creado" -ForegroundColor Green

# 3. Crear VM sin red (Generation 1 = BIOS legacy)
Write-Host "Creando maquina virtual..."
New-VM -Name "nexos" -MemoryStartupBytes 4GB -Generation 1 -VHDPath "C:\ProgramData\Microsoft\Windows\Virtual Hard Disks\nexos.vhdx"
Write-Host "[OK] VM creada" -ForegroundColor Green

# 4. Quitar adaptador de red (evitar error de switch)
Get-VMNetworkAdapter -VMName "nexos" | Remove-VMNetworkAdapter
Write-Host "[OK] Adaptador de red eliminado (evita error)" -ForegroundColor Green

# 5. Configurar 2 CPUs
Set-VMProcessor -VMName "nexos" -Count 2
Write-Host "[OK] 2 CPUs asignadas" -ForegroundColor Green

# 6. Montar ISO
$isoPath = Join-Path $env:USERPROFILE "Downloads\NexOS-ISO\nexos-v1-amd64.iso"
if (Test-Path $isoPath) {
    Set-VMDvdDrive -VMName "nexos" -Path $isoPath
    Write-Host "[OK] ISO montada: $isoPath" -ForegroundColor Green
} else {
    Write-Host "[ERROR] ISO no encontrada en: $isoPath" -ForegroundColor Red
    Write-Host "Coloca la ISO en esa ruta e intentalo de nuevo." -ForegroundColor Yellow
    Read-Host "Pulsa Enter para salir"
    exit 1
}

# 7. Arranque desde DVD primero
Set-VMBios -VMName "nexos" -StartupOrder @("CD","IDE","LegacyNetworkAdapter","Floppy")
Write-Host "[OK] Orden de arranque: DVD primero" -ForegroundColor Green

# 8. Iniciar VM
Write-Host ""
Write-Host "Iniciando VM..." -ForegroundColor Yellow
Start-VM -Name "nexos"
Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "  VM NexOS CREADA E INICIADA!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""

# 9. Abrir ventana de conexion
Write-Host "Abriendo conexion a la VM..."
vmconnect localhost nexos

Read-Host "Pulsa Enter para cerrar esta ventana"
