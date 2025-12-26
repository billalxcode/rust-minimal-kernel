#![no_std]
#![no_main]

use core::panic::PanicInfo;
use bootloader::MultibootHeader;
use osdev_utils::vga::{VgaWriter, Color, ColorCode};

/// Halt the CPU
fn x86_halt() {
    loop {} // Simple busy loop instead of hlt
}

// Multiboot header for GRUB compatibility
#[used]
#[link_section = ".multiboot"]
static MULTIBOOT_HEADER: MultibootHeader = MultibootHeader::new();

// Entry point for GRUB multiboot
#[no_mangle]
pub extern "C" fn _start() -> ! {
    kernel_main();
}

fn kernel_main() -> ! {
    let mut vga = VgaWriter::new();
    
    // Clear screen with dark background
    vga.clear_screen(ColorCode::new(Color::LightGray, Color::Black));
    
    // Write welcome message
    let welcome_msg = b"Rust OS Kernel v0.1.0";
    vga.write_string(
        welcome_msg, 
        0, 
        (80 - welcome_msg.len()) / 2, 
        ColorCode::new(Color::Yellow, Color::Black)
    );
    
    // Write status messages
    vga.write_string(
        b"[OK] Kernel loaded successfully", 
        2, 
        2, 
        ColorCode::new(Color::LightGreen, Color::Black)
    );
    
    vga.write_string(
        b"[OK] VGA text mode initialized", 
        3, 
        2, 
        ColorCode::new(Color::LightGreen, Color::Black)
    );
    
    vga.write_string(
        b"[OK] Multiboot protocol active", 
        4, 
        2, 
        ColorCode::new(Color::LightGreen, Color::Black)
    );
    
    // System ready message
    vga.write_string(
        b"System ready - Kernel running in protected mode", 
        6, 
        2, 
        ColorCode::new(Color::LightCyan, Color::Black)
    );

    // Infinite loop with halt
    loop {
        x86_halt();
    }
}

#[panic_handler]
fn panic(info: &PanicInfo) -> ! {
    let mut vga = VgaWriter::new();
    
    // Clear screen to red background for panic
    vga.clear_screen(ColorCode::new(Color::White, Color::Red));
    
    // Write panic message
    vga.write_string(
        b"KERNEL PANIC!", 
        0, 
        (80 - 13) / 2, 
        ColorCode::new(Color::White, Color::Red)
    );
    
    // Write panic location if available
    if let Some(_location) = info.location() {
        let panic_location = b"Check console for details";
        vga.write_string(
            panic_location, 
            2, 
            (80 - panic_location.len()) / 2, 
            ColorCode::new(Color::Yellow, Color::Red)
        );
    }
    
    loop {
        x86_halt();
    }
}