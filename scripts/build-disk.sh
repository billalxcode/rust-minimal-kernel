#!/bin/bash
set -e

echo "=== Building Simple Bootable Kernel ==="

# Build kernel
echo "[*] Building kernel..."
cd kernel  
cargo build --release
cd ..

# Create a simple disk image instead of CD
echo "[*] Creating disk image..."
dd if=/dev/zero of=kernel.img bs=1M count=10 2>/dev/null

# Create filesystem
echo "[*] Creating filesystem..."
mkfs.fat -F 16 kernel.img

# Mount and copy files
echo "[*] Copying kernel to disk image..."
mkdir -p /tmp/mnt
sudo mount -o loop kernel.img /tmp/mnt
sudo mkdir -p /tmp/mnt/boot
sudo cp kernel/target/x86_64-osdev-rust/release/kernel /tmp/mnt/boot/kernel.elf

# Create GRUB config on the mounted filesystem  
sudo mkdir -p /tmp/mnt/boot/grub
sudo cp grub.cfg /tmp/mnt/boot/grub/

# Install GRUB to the disk image
echo "[*] Installing GRUB bootloader..."
sudo grub-install --target=i386-pc --boot-directory=/tmp/mnt/boot --force kernel.img

sudo umount /tmp/mnt
rmdir /tmp/mnt

echo ""
echo "✅ Bootable disk image created: kernel.img"
echo ""
echo "To test your kernel, run:"
echo "  qemu-system-x86_64 -hda kernel.img -m 512M"