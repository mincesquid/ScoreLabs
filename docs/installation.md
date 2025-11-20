# ScoreLabs Installation Guide

## Overview

ScoreLabs can be installed in several ways depending on your use case:
- **Live USB**: Run from USB without installation
- **Virtual Machine**: Test in an isolated VM environment
- **Bare Metal**: Full installation on physical hardware
- **Dual Boot**: Install alongside existing OS

## System Requirements

### Minimum Requirements
- **Processor**: 64-bit x86_64 CPU
- **RAM**: 4 GB
- **Storage**: 20 GB free space
- **Graphics**: Any VGA-compatible display

### Recommended Requirements
- **Processor**: Multi-core 64-bit x86_64 CPU
- **RAM**: 8 GB or more
- **Storage**: 50 GB SSD
- **Graphics**: GPU with hardware acceleration
- **Network**: Wireless adapter for wireless security testing

## Building the ISO

### On Arch Linux

1. **Install dependencies:**
   ```bash
   sudo pacman -S archiso squashfs-tools
   ```

2. **Clone the repository:**
   ```bash
   git clone https://github.com/yourusername/scorelabs.git
   cd scorelabs
   ```

3. **Build the ISO:**
   ```bash
   ./build.sh
   ```

4. **Find the ISO:**
   ```bash
   ls -lh build/output/*.iso
   ```

### On Other Linux Distributions

While ScoreLabs is designed to be built on Arch Linux, you can build it from other distributions using Docker:

```bash
docker run -it --privileged \
  -v $(pwd):/workspace \
  archlinux:latest \
  bash -c "pacman -Syu --noconfirm archiso && cd /workspace && ./build.sh"
```

### Using Podman or Docker on macOS

If you see an error such as:

```
Failed to get networks: Error: Command failed: podman network ls --format "{{.Name}}|{{.Driver}}"
/bin/sh: podman: command not found
```

This means the environment expects Podman to be installed. On macOS you can:

- Install Podman with Homebrew (then initialize a VM):

```bash
brew install podman
podman machine init
podman machine start
# verify networks
podman network ls
```

- Or use Docker Desktop for macOS (recommended for macOS users):

   1. Install Docker Desktop from https://www.docker.com
   2. Start Docker Desktop and verify with `docker info`
   3. Replace podman calls with `docker` if needed, or use the helper script below.

We included a helper script that detects which engine is available and lists networks:

```bash
chmod +x scripts/detect-networks.sh
./scripts/detect-networks.sh
```

## Creating Bootable Media

### Using dd (Linux/macOS)

```bash
# Find your USB device (be careful!)
lsblk

# Write ISO to USB (replace /dev/sdX with your device)
sudo dd if=build/output/scorelabs-*.iso of=/dev/sdX bs=4M status=progress oflag=sync
```

### Using Ventoy

1. Install [Ventoy](https://www.ventoy.net/) on your USB drive
2. Copy the ISO file to the Ventoy USB drive
3. Boot from USB and select ScoreLabs

### Using Etcher (Cross-platform)

1. Download [balenaEtcher](https://www.balena.io/etcher/)
2. Select the ScoreLabs ISO
3. Select your USB drive
4. Click "Flash!"

## Installation Methods

### Live USB (No Installation)

1. Boot from the USB drive
2. Select "Boot ScoreLabs (live)" from the menu
3. Log in with default credentials (if prompted):
   - Username: `scorelabs`
   - Password: `scorelabs`

### Virtual Machine Installation

#### VMware Workstation/Fusion

1. Create new VM, select "Linux" and "Other Linux 5.x kernel 64-bit"
2. Allocate at least 4 GB RAM and 2 CPU cores
3. Create a 50 GB virtual disk
4. Attach the ScoreLabs ISO to the CD/DVD drive
5. Boot and follow installation

#### VirtualBox

1. Create new VM, type "Linux", version "Arch Linux (64-bit)"
2. Allocate at least 4 GB RAM
3. Create a 50 GB VDI disk
4. Settings → Storage → Add ISO to optical drive
5. Boot and follow installation

#### QEMU/KVM

```bash
# Create disk image
qemu-img create -f qcow2 scorelabs.qcow2 50G

# Boot from ISO
qemu-system-x86_64 \
  -enable-kvm \
  -m 4096 \
  -smp 2 \
  -cdrom build/output/scorelabs-*.iso \
  -boot d \
  -drive file=scorelabs.qcow2,format=qcow2
```

### Bare Metal Installation

1. **Boot from USB**
   - Insert USB and boot from it
   - Select "Install ScoreLabs"

2. **Connect to Network** (if needed)
   ```bash
   # WiFi
   iwctl
   station wlan0 connect "Your-Network"
   
   # Wired (usually automatic)
   dhcpcd
   ```

3. **Partition Disk**
   ```bash
   # List disks
   lsblk
   
   # Use cfdisk for easy partitioning
   cfdisk /dev/sda
   
   # Example layout:
   # /dev/sda1  512M  EFI System
   # /dev/sda2  Rest  Linux filesystem
   ```

4. **Format Partitions**
   ```bash
   # Format EFI partition
   mkfs.fat -F32 /dev/sda1
   
   # Format root partition
   mkfs.ext4 /dev/sda2
   ```

5. **Mount Partitions**
   ```bash
   mount /dev/sda2 /mnt
   mkdir -p /mnt/boot/efi
   mount /dev/sda1 /mnt/boot/efi
   ```

6. **Install Base System**
   ```bash
   pacstrap /mnt base base-devel linux linux-firmware
   ```

7. **Generate fstab**
   ```bash
   genfstab -U /mnt >> /mnt/etc/fstab
   ```

8. **Chroot and Configure**
   ```bash
   arch-chroot /mnt
   
   # Set timezone
   ln -sf /usr/share/zoneinfo/Region/City /etc/localtime
   hwclock --systohc
   
   # Set locale
   echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
   locale-gen
   echo "LANG=en_US.UTF-8" > /etc/locale.conf
   
   # Set hostname
   echo "scorelabs" > /etc/hostname
   
   # Set root password
   passwd
   ```

9. **Install Bootloader**
   ```bash
   pacman -S grub efibootmgr
   grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=ScoreLabs
   grub-mkconfig -o /boot/grub/grub.cfg
   ```

10. **Install ScoreLabs Packages**
    ```bash
    # Install networking
    pacman -S networkmanager
    systemctl enable NetworkManager
    
    # Install desktop (optional)
    pacman -S xfce4 lightdm
    systemctl enable lightdm
    
    # Install security tools
    scorelabs-cli install --suite forensics
    scorelabs-cli install --suite pentesting
    ```

11. **Create User**
    ```bash
    useradd -m -G wheel -s /bin/bash scorelabs
    passwd scorelabs
    
    # Enable sudo
    EDITOR=nano visudo
    # Uncomment: %wheel ALL=(ALL:ALL) ALL
    ```

12. **Reboot**
    ```bash
    exit
    umount -R /mnt
    reboot
    ```

## Post-Installation

### Update System
```bash
sudo pacman -Syu
```

### Install Additional Tools
```bash
scorelabs-cli list
scorelabs-cli install --suite wireless
scorelabs-cli install --suite reversing
```

### Configure Network
```bash
# Enable NetworkManager
sudo systemctl enable --now NetworkManager

# Connect to WiFi
nmcli device wifi connect "SSID" password "password"
```

### Set Up Sandbox Environment
```bash
scorelabs-cli sandbox create test-env
```

### Explore Labs
```bash
scorelabs-cli lab list
scorelabs-cli lab start intro-to-nmap
```

## Troubleshooting

### Boot Issues

**Problem**: System won't boot from USB
- **Solution**: Check BIOS/UEFI settings, disable Secure Boot

**Problem**: GRUB error
- **Solution**: Reinstall GRUB from live environment

### Network Issues

**Problem**: WiFi not working
```bash
# Check device
ip link

# Install firmware if needed
sudo pacman -S linux-firmware

# Restart NetworkManager
sudo systemctl restart NetworkManager
```

### Display Issues

**Problem**: No display or low resolution
```bash
# Install graphics drivers
sudo pacman -S xf86-video-intel    # Intel
sudo pacman -S xf86-video-amdgpu   # AMD
sudo pacman -S nvidia              # NVIDIA
```

## Getting Help

- **Documentation**: Check the `docs/` directory
- **GitHub Issues**: Report bugs and ask questions
- **Community**: Join our community chat

## Next Steps

- [Architecture Overview](architecture.md)
- [Tool Reference](tools.md)
- [Lab Scenarios](labs/README.md)
- [Sandbox Guide](sandbox.md)
