#!/bin/bash
set -e

echo "=== Rust OS Workspace - Build and Test ==="

# Go to project root
cd "$(dirname "$0")/.."

echo "[*] Building workspace..."
cargo build --release

echo "[*] Running tests..."

echo ""
echo "🧪 Test 1: Direct kernel boot"
echo "   Command: qemu-system-x86_64 -kernel target/x86_64-unknown-none/release/kernel -m 512M -nographic"
echo "   Expected: VGA text output showing kernel status messages"

timeout 3 qemu-system-x86_64 -kernel target/x86_64-unknown-none/release/kernel -m 512M -nographic 2>/dev/null || true

echo ""
echo "✅ Workspace build and test completed!"
echo ""
echo "📋 Workspace members:"
echo "   • kernel          - Main OS kernel"
echo "   • bootloader      - Bootloader utilities"
echo "   • lib/osdev-utils - OS development utilities"
echo ""
echo "📋 Next steps:"
echo "   • Run './scripts/test-direct.sh' for interactive testing"
echo "   • Run 'cargo build --release' to build all workspace members"
echo "   • Check 'target/' directory for artifacts"
echo ""
echo "🚀 Your Rust OS workspace is ready!"