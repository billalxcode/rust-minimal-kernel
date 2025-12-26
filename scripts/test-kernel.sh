#!/bin/bash
echo "Testing kernel boot..."
timeout 3 qemu-system-x86_64 -cdrom osdev.iso -m 512M -display none -vga std -serial file:boot.log -monitor none &
QEMU_PID=$!
sleep 3
kill $QEMU_PID 2>/dev/null
wait $QEMU_PID 2>/dev/null

if [ -f boot.log ]; then
    echo "Kernel output:"
    cat boot.log
    rm boot.log
else
    echo "No serial output captured"
fi