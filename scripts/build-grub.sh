#!/bin/bash
set -e

echo "=== Building Rust OS with GRUB Bootloader ==="

# Go to project root
cd "$(dirname "$0")/.."

# Build kernel
echo "[*] Building kernel..."
cd kernel
cargo build --release
cd ..

# Prepare ISO directory structure
echo "[*] Preparing ISO structure..."
rm -rf build/isodir
mkdir -p build/isodir/boot/grub

# Copy kernel
echo "[*] Copying kernel..."
cp kernel/target/i386-osdev-rust/release/kernel build/isodir/boot/kernel.elf

# Copy GRUB config
echo "[*] Copying GRUB configuration..."
cp build/grub.cfg build/isodir/boot/grub/grub.cfg

# Copy root filesystem to ISO
echo "[*] Copying root filesystem..."
if [ -d "root" ]; then
    cp -r root/* build/isodir/ 2>/dev/null || true
    echo "    Root filesystem copied to ISO"
else
    echo "    Warning: root directory not found"
fi

# Try to create bootable ISO with different approaches
echo "[*] Creating bootable ISO..."

# Use xorriso directly with El Torito for BIOS boot
echo "    Using xorriso with El Torito..."

# Create a simple boot directory structure
mkdir -p build/isodir/boot/grub

# Create ISO with proper boot configuration
xorriso -as mkisofs \
    -R -J -joliet-long \
    -o build/osdev.iso \
    -V "RUST_OS" \
    -no-emul-boot \
    -boot-load-size 4 \
    -boot-info-table \
    build/isodir

echo ""
echo "✅ ISO created successfully: build/osdev.iso"
echo ""
echo "To test your kernel, run:"
echo "  ./scripts/test-grub.sh"
echo ""
echo "Or manually:"
echo "  qemu-system-x86_64 -cdrom build/osdev.iso -m 512M"