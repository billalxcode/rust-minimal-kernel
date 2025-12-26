# Rust OS Kernel

A simple operating system kernel written in Rust, targeting x86 32-bit architecture with multiboot support.

## 🚀 Quick Start

```bash
# Build and test the kernel
./scripts/build-and-test.sh

# Or manually:
cd kernel && cargo build --release && cd ..
qemu-system-x86_64 -kernel kernel/target/i386-osdev-rust/release/kernel -m 512M
```

## 📁 Project Structure

```
├── kernel/               # Rust kernel source code
│   ├── src/             # Kernel source files
│   ├── Cargo.toml       # Rust project configuration
│   ├── linker.ld        # Linker script for multiboot
│   └── .cargo/          # Cargo configuration
├── scripts/             # Build and utility scripts
├── build/               # Build artifacts and configurations
├── tools/               # External tools and dependencies
├── libs/                # Git submodules for libraries
└── docs/                # Documentation
```

## 🛠️ Development

### Prerequisites

- Rust nightly toolchain
- QEMU (for testing)
- Basic build tools

### Building

The kernel uses a custom i386 target specification and multiboot protocol.

```bash
# Build kernel
cd kernel
cargo build --release

# Create bootable ISO (optional)
./scripts/build-grub.sh
```

### Testing

```bash
# Direct kernel loading (recommended)
./scripts/test-direct.sh

# Or manually
qemu-system-x86_64 -kernel kernel/target/i386-osdev-rust/release/kernel -m 512M
```

## 🔧 Architecture

- **Target**: i386 (32-bit x86)
- **Bootloader**: Multiboot compatible (works with GRUB/QEMU)
- **Language**: Rust (no_std)
- **Features**: VGA text mode output, basic kernel structure

## 📝 License

MIT License - See LICENSE file for details