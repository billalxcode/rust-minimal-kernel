#![no_std]
#![no_main]

use bootloader::MultibootHeader;
use core::panic::PanicInfo;
use osdev_utils::vga::{Color, ColorCode, VgaWriter};

/// Halt the CPU
fn x86_halt() {
    unsafe {
        core::arch::asm!("hlt", options(nomem, nostack, preserves_flags));
    }
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

    // Clear screen to black
    vga.clear_screen(ColorCode::new(Color::White, Color::Black));

    vga.write_string(
        b"Hello World from @billalxcode",
        0,
        0,
        ColorCode::new(Color::Blue, Color::Black),
    );

    vga.write_string(
        b"Hello World",
        1,
        0,
        ColorCode::new(Color::Green, Color::Black),
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
        10,
        (80 - 13) / 2,
        ColorCode::new(Color::White, Color::Red),
    );

    // Write panic location if available
    if let Some(_location) = info.location() {
        let panic_location = b"Check console for details";
        vga.write_string(
            panic_location,
            12,
            (80 - panic_location.len()) / 2,
            ColorCode::new(Color::Yellow, Color::Red),
        );
    }

    loop {
        x86_halt();
    }
}
