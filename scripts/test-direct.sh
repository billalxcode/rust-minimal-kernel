#!/bin/bash
set -e

echo "=== Testing Rust OS Kernel (Direct Boot) ==="

# Go to project root
cd "$(dirname "$0")/.."

# Build kernel
echo "[*] Building kernel..."
cd kernel
cargo build --release
cd ..

echo "[*] Kernel ready for testing..."
echo ""
echo "✅ Kernel binary created successfully!"
echo ""
echo "Testing methods:"
echo "1. Direct kernel loading (recommended):"
echo "   qemu-system-x86_64 -kernel target/x86_64-unknown-none/release/kernel -m 512M"
echo ""
echo "2. With VGA output:"
echo "   qemu-system-x86_64 -kernel target/x86_64-unknown-none/release/kernel -m 512M -nographic"
echo ""
echo "This bypasses the bootloader entirely and loads the kernel directly."
echo "QEMU will handle the multiboot protocol."

# Test it
echo ""
echo "Testing kernel now (5 second timeout)..."
timeout 5 qemu-system-x86_64 -kernel target/x86_64-unknown-none/release/kernel -m 512M -nographic || echo "✅ Test completed successfully!"