qemu-system-aarch64 \
  -machine virt \
  -cpu cortex-a53 \
  -nographic \
  -serial mon:stdio \
  -display none \
  -kernel target/aarch64-unknown-kernel/release/telos