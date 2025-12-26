# Rust OS Makefile

.PHONY: all build test clean setup iso run help

# Default target
all: build

# Build the kernel
build:
	@echo "🔨 Building kernel..."
	@cd kernel && cargo build --release

# Test the kernel directly
test: build
	@echo "🧪 Testing kernel..."
	@./scripts/test-direct.sh

# Build ISO image
iso: build
	@echo "💿 Creating ISO..."
	@./scripts/build-grub.sh

# Run kernel in QEMU
run: build
	@echo "🚀 Running kernel in QEMU..."
	@qemu-system-x86_64 -kernel kernel/target/i386-osdev-rust/release/kernel -m 512M

# Run with VGA output
run-text: build
	@echo "📺 Running kernel with text output..."
	@qemu-system-x86_64 -kernel kernel/target/i386-osdev-rust/release/kernel -m 512M -nographic

# Setup development environment
setup:
	@echo "⚙️  Setting up development environment..."
	@./scripts/setup-submodules.sh

# Clean build artifacts
clean:
	@echo "🧹 Cleaning..."
	@./scripts/cleanup.sh

# Full build and test
check: build test

# Show help
help:
	@echo "🦀 Rust OS Development Commands:"
	@echo ""
	@echo "  make build     - Build the kernel"
	@echo "  make test      - Build and test kernel"
	@echo "  make run       - Run kernel in QEMU"
	@echo "  make run-text  - Run kernel with text output"
	@echo "  make iso       - Create bootable ISO"
	@echo "  make setup     - Setup git submodules"
	@echo "  make clean     - Clean build artifacts"
	@echo "  make check     - Build and test everything"
	@echo "  make help      - Show this help"
	@echo ""