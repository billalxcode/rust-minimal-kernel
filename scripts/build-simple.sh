#!/bin/bash
set -e

echo "=== Building Bootable Kernel with mcopy ==="

# Build kernel
echo "[*] Building kernel..."
cd kernel  
cargo build --release
cd ..

# Create a simple disk image
echo "[*] Creating disk image..."
dd if=/dev/zero of=kernel.img bs=1M count=10 2>/dev/null
mkfs.fat -F 16 kernel.img

# Use mtools to copy files without mounting
echo "[*] Creating directory structure..."
mmd -i kernel.img ::boot
mmd -i kernel.img ::boot/grub

echo "[*] Copying kernel..."
mcopy -i kernel.img kernel/target/x86_64-osdev-rust/release/kernel ::boot/kernel.elf

echo "[*] Copying GRUB config..."
mcopy -i kernel.img grub.cfg ::boot/grub/grub.cfg

echo ""
echo "✅ Disk image created: kernel.img"
echo ""
echo "To test your kernel, run:"
echo "  qemu-system-x86_64 -hda kernel.img -m 512M"
echo ""
echo "Note: This disk image doesn't have a bootloader installed."
echo "For a fully bootable image, use the ISO approach or install GRUB."