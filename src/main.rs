#![no_std]
#![no_main]

use core::arch::asm;

mod drivers;
mod panic;

#[unsafe(no_mangle)]
pub extern "C" fn _start() -> ! {
    unsafe {
        drivers::uart::base::uart_init();
        drivers::uart::base::uart_write_str("Hello, Telos!\n");
        drivers::uart::base::uart_write_str("Kernel is running...\n");
    }
    
    // Simple infinite loop without WFI
    loop {}
}
