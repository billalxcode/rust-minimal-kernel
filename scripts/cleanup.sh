#!/bin/bash

echo "=== Cleaning Build Artifacts ==="

# Go to project root
cd "$(dirname "$0")/.."

echo "[*] Cleaning kernel build..."
cd kernel && cargo clean && cd ..

echo "[*] Cleaning build artifacts..."
rm -rf build/isodir/
rm -f build/*.iso
rm -f build/*.img
rm -f build/*.log

echo "[*] Cleaning temporary files..."
find . -name "*.tmp" -delete
find . -name "*~" -delete
find . -name "*.log" -delete

echo ""
echo "✅ Cleanup completed!"
echo ""
echo "🧹 Cleaned:"
echo "   • Kernel build artifacts"
echo "   • ISO/disk images"
echo "   • Temporary files"
echo "   • Log files"
echo ""
echo "📁 Preserved:"
echo "   • Source code"
echo "   • Configuration files"  
echo "   • Git submodules"