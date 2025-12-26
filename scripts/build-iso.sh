#!/usr/bin/env bash
set -e

# =========================
# CONFIG
# =========================
KERNEL_DIR="kernel"
ISO_DIR="iso"
LIMINE_SUBDIR="$ISO_DIR/limine"
LIMINE_DIR="limine-10.5.0"
TARGET="i386-osdev-rust"
KERNEL_BIN="kernel.elf"
ISO_NAME="osdev.iso"

# =========================
# CHECK DEPENDENCIES
# =========================
command -v cargo >/dev/null || { echo "cargo not found"; exit 1; }
command -v xorriso >/dev/null || { echo "xorriso not found"; exit 1; }

# =========================
# BUILD KERNEL
# =========================
echo "[*] Building kernel..."
cd "$KERNEL_DIR"
cargo clean
cargo build --release
cd ..

# =========================
# PREPARE ISO STRUCTURE
# =========================
echo "[*] Preparing ISO directory..."
rm -rf "$ISO_DIR"
mkdir -p "$LIMINE_SUBDIR"

# kernel → ROOT ISO
cp "$KERNEL_DIR/target/$TARGET/release/kernel" "$ISO_DIR/$KERNEL_BIN"

# limine config → ROOT ISO
cp limine.cfg "$ISO_DIR/"

# Also copy to common locations Limine checks
cp limine.cfg "$LIMINE_SUBDIR/"

# limine binaries → iso/limine/
cp "$LIMINE_DIR/bin/limine-bios.sys" "$LIMINE_SUBDIR/"
cp "$LIMINE_DIR/bin/limine-bios-cd.bin" "$LIMINE_SUBDIR/"
cp "$LIMINE_DIR/bin/limine-uefi-cd.bin" "$LIMINE_SUBDIR/"

# Also copy limine-bios.sys to root for proper boot
cp "$LIMINE_DIR/bin/limine-bios.sys" "$ISO_DIR/"

# =========================
# BUILD ISO
# =========================
echo "[*] Building ISO..."
# xorriso -as mkisofs \
#   -b limine/limine-bios-cd.bin \
#   -no-emul-boot \
#   -boot-load-size 4 \
#   -boot-info-table \
#   --efi-boot limine/limine-uefi-cd.bin \
#   -efi-boot-part \
#   --efi-boot-image \
#   -o "$ISO_NAME" \
#   "$ISO_DIR"

xorriso -as mkisofs -R -r -J -b limine/limine-bios-cd.bin \
        -no-emul-boot -boot-load-size 4 -boot-info-table -hfsplus \
        -apm-block-size 2048 --efi-boot limine/limine-uefi-cd.bin \
        -efi-boot-part --efi-boot-image --protective-msdos-label \
        "$ISO_DIR" -o "$ISO_NAME"

# Install Limine BIOS stage
"$LIMINE_DIR/bin/limine" bios-install "$ISO_NAME"

echo "[✓] ISO built successfully: $ISO_NAME"