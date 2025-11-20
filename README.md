# ResolveOS ISO Builder

<p align="center">
  <strong>A custom Arch-based Linux distribution with XFCE desktop environment</strong>
</p>

## About ResolveOS

ResolveOS is a custom Arch-based Linux distribution built using the `archiso` framework. It features the XFCE desktop environment and includes the Calamares graphical installer for easy installation.

### Key Features

- **Base System**: Built on Arch Linux rolling release
- **Desktop Environment**: XFCE 4.x with custom configurations
- **Installer**: Calamares graphical installer with ResolveOS branding
- **Boot Systems**: Supports both BIOS (Syslinux) and UEFI (GRUB)
- **Package Management**: Uses Arch repositories + optional personal repositories
- **Version**: v24.05.01

## Repository Structure

The repository contains:
- **archiso/**: Main ISO build directory with airootfs (root filesystem overlay), boot configs (efiboot, grub, syslinux), package lists, and build scripts
- **installation-scripts/**: Build scripts for first-time and rebuild scenarios, plus repository configurations
- **personal/**: Custom content for airootfs

## Prerequisites

### Required Packages

```bash
sudo pacman -Syu
sudo pacman -S --needed \
    git \
    base-devel \
    archiso \
    rsync \
    squashfs-tools
```

### Recommended Version

- **archiso**: Version 76-1 or compatible

## Building the ISO

### Method 1: Using the Automated Build Script (Recommended)

The simplest way to build the ISO:

```bash
cd /home/manish/resolveos-work/resolveos-iso/archiso
./build-iso.sh
```

This script automatically handles package conflicts by providing default responses:
- Uses default (all) for xorg-apps
- Selects iptables (option 1)
- Selects pipewire-jack (option 2)
- Selects audacity for ladspa-host (option 2)

**Output**: `out/resolveos-v24.05.01-x86_64.iso`

### Method 2: Using Installation Scripts

For first-time build with full configuration:

```bash
cd /home/manish/resolveos-work/resolveos-iso/installation-scripts
./30-build-the-iso-the-first-time.sh
```

For rebuilds (faster, skips pacman cache cleaning):

```bash
cd /home/manish/resolveos-work/resolveos-iso/installation-scripts
./40-build-the-iso-local-again.sh
```

These scripts perform:
1. Copy archiso structure to `~/resolveos-build`
2. Download latest `.bashrc` for `/etc/skel`
3. Copy package lists
4. Add personal repository (if enabled)
5. Build ISO with `mkarchiso`
6. Generate checksums (SHA1, SHA256, MD5)
7. Create package list

**Build output**: `~/ResolveOS-Out/`

### Method 3: Manual Build

```bash
cd /home/manish/resolveos-work/resolveos-iso/archiso

# Clean previous builds (if any)
sudo rm -rf work out

# Build the ISO
sudo mkarchiso -v -w work -o out .
```

## Configuration

### System Identity

**File**: `archiso/airootfs/etc/os-release`
```ini
NAME="ResolveOS"
PRETTY_NAME="ResolveOS"
ID=resolveos
ID_LIKE=arch
BUILD_ID=rolling
```

**File**: `archiso/airootfs/etc/hostname`
```
resolveos
```

### ISO Profile

**File**: `archiso/profiledef.sh`
- ISO name: `resolveos`
- ISO label: `resolveos-v24.05.01`
- Version: `v24.05.01`
- Architecture: `x86_64`
- Boot modes: BIOS (Syslinux) and UEFI (GRUB)

### Desktop Environment

- **Desktop**: XFCE
- **Session Manager**: Set in `archiso/airootfs/etc/sddm.conf`

### Package Management

**Main packages**: `archiso/packages.x86_64`
- Contains all system and desktop packages
- Base system, XFCE, utilities, drivers, etc.

**Personal repo packages**: `archiso/packages-personal-repo.x86_64`
- Optional custom packages
- Enabled via `personalrepo=true` in build scripts

## Personal Repository Setup

To use your own package repository:

1. **Enable in build scripts**:
   ```bash
   personalrepo=true
   ```

2. **Configure repository**:
   Edit `installation-scripts/personal-repo` with your repository URL and keyring.

3. **Add packages**:
   List your packages in `archiso/packages-personal-repo.x86_64`

## Testing the ISO

### Using VirtualBox

1. Create a new VM:
   - **Type**: Linux / Arch Linux (64-bit)
   - **RAM**: 4GB minimum
   - **Disk**: 25GB
   - **Enable EFI**: For UEFI boot testing

2. Attach the ISO: `out/resolveos-v24.05.01-x86_64.iso`

3. Boot and test:
   - Live environment functionality
   - Network connectivity
   - Calamares installer
   - System identification (`neofetch`, `cat /etc/os-release`)

### Using QEMU

```bash
qemu-system-x86_64 \
    -enable-kvm \
    -m 4G \
    -smp 2 \
    -bios /usr/share/ovmf/x64/OVMF.fd \
    -cdrom out/resolveos-v24.05.01-x86_64.iso \
    -boot d
```

## Customization

### Adding Packages

Edit `archiso/packages.x86_64` and add package names (one per line).

### Custom Files

Place files in `archiso/airootfs/` - they will be copied to the root filesystem:
- `airootfs/etc/` → `/etc/`
- `airootfs/usr/` → `/usr/`
- `airootfs/personal/` → `/personal/`

### Boot Configuration

**GRUB (UEFI)**: Edit `archiso/grub/grub.cfg`
**Syslinux (BIOS)**: Edit `archiso/syslinux/*.cfg`

### Splash Screen

Replace `archiso/syslinux/splash.png` with your custom boot splash (640x480px).

## Build Output

After successful build, you'll find in the output directory:

```
resolveos-v24.05.01-x86_64.iso          # ISO image
resolveos-v24.05.01-x86_64.iso.sha1     # SHA1 checksum
resolveos-v24.05.01-x86_64.iso.sha256   # SHA256 checksum
resolveos-v24.05.01-x86_64.iso.md5      # MD5 checksum
resolveos-v24.05.01-x86_64.iso.pkglist.txt  # Package list
```

## Troubleshooting

### Package Conflicts

The `build-iso.sh` script automatically resolves common conflicts. For manual builds:
```bash
(echo ""; echo "1"; echo "2"; echo "2") | sudo mkarchiso -v -w work -o out .
```

### Missing Dependencies

```bash
sudo pacman -S --needed archiso base-devel
```

### Build Fails

1. Clean workspace:
   ```bash
   sudo rm -rf work out
   ```

2. Check archiso version:
   ```bash
   pacman -Q archiso
   ```

3. Update system:
   ```bash
   sudo pacman -Syu
   ```

### Permission Errors

Ensure you're running `mkarchiso` with `sudo`:
```bash
sudo mkarchiso -v -w work -o out .
```

## Related Repository

- **[resolveos-calamares-config](../resolveos-calamares-config/)**: Calamares installer configuration and branding

## Contributing

This is a personal project based on ArcoLinux templates. Feel free to fork and customize for your needs.

## Resources

- **Arch Linux**: https://archlinux.org/
- **archiso Wiki**: https://wiki.archlinux.org/title/Archiso
- **Calamares**: https://calamares.io/
- **XFCE**: https://xfce.org/

## License

See individual files for licensing information. Based on ArcoLinux which is GPL-licensed.

---

**Last Updated**: November 20, 2025  
**Version**: v24.05.01  
**Base**: Arch Linux (rolling release)
