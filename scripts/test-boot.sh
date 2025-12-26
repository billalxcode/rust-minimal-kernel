#!/bin/bash

echo "=== Testing Kernel Boot ==="

# Test ISO with detailed QEMU output
timeout 10 qemu-system-x86_64 -cdrom osdev.iso -m 512M -nographic -d int,cpu_reset 2>&1 | head -20

echo ""
echo "If you see any output above, the ISO is being read."
echo "If you see 'No bootable device', there's a boot sector issue."