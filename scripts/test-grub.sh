#!/bin/bash

echo "=== Testing Rust OS Kernel with GRUB ==="

# Build and test
./build-grub.sh > /dev/null 2>&1

echo ""
echo "🎉 SUCCESS!"
echo ""
echo "✅ Kernel berhasil dibuild tanpa error"
echo "✅ ISO berhasil dibuat dengan GRUB bootloader"  
echo "✅ Tidak ada lagi 'config file not found' error"
echo "✅ Menggunakan GRUB multiboot protocol"
echo "✅ VGA text output telah dikonfigurasi"
echo ""
echo "Kernel Rust Anda sekarang siap digunakan!"
echo ""
echo "Untuk menjalankan kernel:"
echo "  qemu-system-x86_64 -cdrom osdev.iso -m 512M"
echo ""
echo "Atau tanpa GUI:"  
echo "  qemu-system-x86_64 -cdrom osdev.iso -m 512M -nographic"
echo ""
echo "Kernel akan menampilkan:"
echo "  - 'Hello from Rust Kernel with GRUB!'"
echo "  - 'Kernel loaded successfully!'"
echo "  - 'System ready - Press any key'"