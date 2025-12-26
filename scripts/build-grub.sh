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

# First try with grub-mkrescue
if command -v grub-mkrescue >/dev/null 2>&1; then
    echo "    Using grub-mkrescue..."
    grub-mkrescue -o build/osdev.iso build/isodir
else
    echo "    grub-mkrescue not available, using alternative method..."
    
    # Create ISO manually with xorriso
    mkdir -p build/isodir/boot/grub/i386-pc
    
    # Try to find GRUB core image
    if [ -f /usr/lib/grub/i386-pc/boot.img ]; then
        cp /usr/lib/grub/i386-pc/boot.img build/isodir/boot/grub/i386-pc/
    fi
    
    if [ -f /usr/lib/grub/i386-pc/cdboot.img ]; then
        cp /usr/lib/grub/i386-pc/cdboot.img build/isodir/boot/grub/i386-pc/
    fi
    
    # Create ISO with xorriso
    xorriso -as mkisofs \
        -R -J \
        -b boot/grub/i386-pc/cdboot.img \
        -no-emul-boot \
        -boot-load-size 4 \
        -boot-info-table \
        -o build/osdev.iso \
        build/isodir
fi

echo ""
echo "✅ ISO created successfully: build/osdev.iso"
echo ""
echo "To test your kernel, run:"
echo "  ./scripts/test-grub.sh"
echo ""
echo "Or manually:"
echo "  qemu-system-x86_64 -cdrom build/osdev.iso -m 512M"