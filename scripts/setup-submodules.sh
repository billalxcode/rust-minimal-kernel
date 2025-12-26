#!/bin/bash
set -e

echo "=== Setting up Git Submodules ==="

# Go to project root
cd "$(dirname "$0")/.."

# Remove old tools directory content
rm -rf tools/*

echo "[*] Adding useful OS development libraries as submodules..."

# Add bootloader and useful libraries as git submodules
echo "   Adding limine bootloader..."
git submodule add https://github.com/limine-bootloader/limine.git libs/limine 2>/dev/null || echo "   limine already exists"

echo "   Adding rust-osdev libraries..."
git submodule add https://github.com/rust-osdev/bootloader.git libs/bootloader 2>/dev/null || echo "   bootloader already exists"
git submodule add https://github.com/rust-osdev/x86_64.git libs/x86_64 2>/dev/null || echo "   x86_64 already exists"

echo ""
echo "[*] Initializing and updating submodules..."
git submodule update --init --recursive

echo ""
echo "✅ Git submodules setup completed!"
echo ""
echo "📁 Available libraries:"
echo "   • libs/limine/          - Limine bootloader"
echo "   • libs/bootloader/      - Rust bootloader crate"
echo "   • libs/x86_64/          - x86_64 architecture support"
echo ""
echo "💡 You can now reference these libraries in your kernel development."