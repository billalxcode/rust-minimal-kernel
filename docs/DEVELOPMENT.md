# Development Guide

## 🛠️ Development Workflow

### Quick Commands

```bash
# Build and test (recommended)
make test

# Just build
make build

# Run in QEMU
make run

# Run with text output
make run-text

# Create ISO
make iso

# Clean everything
make clean
```

### Manual Commands

```bash
# Build kernel
cd kernel && cargo build --release

# Test directly
qemu-system-x86_64 -kernel kernel/target/i386-osdev-rust/release/kernel -m 512M

# Create ISO
./scripts/build-grub.sh

# Test ISO
qemu-system-x86_64 -cdrom build/osdev.iso -m 512M
```

## 📁 Directory Structure

```
├── kernel/              # Kernel source code
│   ├── src/            # Rust source files
│   │   └── main.rs     # Main kernel code
│   ├── Cargo.toml      # Rust project config
│   ├── linker.ld       # Linker script
│   └── .cargo/         # Cargo configuration
├── scripts/            # Build and utility scripts
│   ├── build-and-test.sh    # Main build script
│   ├── test-direct.sh       # Direct kernel testing  
│   ├── build-grub.sh        # ISO creation
│   ├── setup-submodules.sh  # Git submodules setup
│   └── cleanup.sh           # Clean build artifacts
├── build/              # Build outputs and configs
│   ├── grub.cfg        # GRUB configuration
│   ├── osdev.iso       # Generated ISO (after build)
│   └── isodir/         # ISO staging directory
├── libs/               # Git submodules for libraries
├── tools/              # External tools and utilities
└── docs/               # Documentation
```

## 🔧 Kernel Architecture

- **Target**: i386 (32-bit x86)
- **Boot Protocol**: Multiboot compatible
- **Language**: Rust (no_std environment)
- **Features**: VGA text mode output, basic kernel structure

## 🧪 Testing

### Direct Kernel Loading (Recommended)
QEMU can load the kernel directly without a bootloader:
```bash
qemu-system-x86_64 -kernel kernel/target/i386-osdev-rust/release/kernel -m 512M
```

### ISO Boot Testing
```bash
./scripts/build-grub.sh
qemu-system-x86_64 -cdrom build/osdev.iso -m 512M
```

## 📚 Adding Dependencies

### Using Git Submodules
```bash
# Setup common OS dev libraries
./scripts/setup-submodules.sh

# Add custom library
git submodule add <repo-url> libs/<name>
```

### Adding Rust Crates
Edit `kernel/Cargo.toml` and add dependencies that support `no_std`.

## 🐛 Debugging

### QEMU Debug Options
```bash
# Debug interrupts and CPU
qemu-system-x86_64 -kernel kernel/target/i386-osdev-rust/release/kernel -d int,cpu_reset

# Debug guest errors
qemu-system-x86_64 -kernel kernel/target/i386-osdev-rust/release/kernel -d guest_errors
```

### GDB Debugging
```bash
# Start QEMU with GDB server
qemu-system-x86_64 -kernel kernel/target/i386-osdev-rust/release/kernel -s -S

# In another terminal
gdb kernel/target/i386-osdev-rust/release/kernel
(gdb) target remote :1234
(gdb) continue
```

## 🔍 Troubleshooting

### Common Issues

1. **"Cannot load x86-64 image"**
   - Ensure target is i386 in `kernel/i386-osdev-rust.json`

2. **"No bootable device"**
   - Use direct kernel loading: `make run`

3. **Build errors**
   - Clean and rebuild: `make clean && make build`