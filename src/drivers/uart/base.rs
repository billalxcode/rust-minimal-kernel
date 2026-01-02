use core::ptr::{read_volatile, write_volatile};

// QEMU virt machine UART0 address
const UART_BASE: usize = 0x0900_0000;

const UART_DR: usize = UART_BASE + 0x00;
const UART_FR: usize = UART_BASE + 0x18;
const UART_IBRD: usize = UART_BASE + 0x24;
const UART_FBRD: usize = UART_BASE + 0x28;
const UART_LCRH: usize = UART_BASE + 0x2C;
const UART_CR: usize = UART_BASE + 0x30;

#[inline(always)]
unsafe fn mmio_write(addr: usize, value: u32) {
    unsafe {
        write_volatile(addr as *mut u32, value);
    }
}

#[inline(always)]
unsafe fn mmio_read(addr: usize) -> u32 {
    unsafe { read_volatile(addr as *const u32) }
}

pub unsafe fn uart_init() {
    unsafe {
        mmio_write(UART_CR, 0x0);

        // Baud rate 115200
        // UARTCLK = 24MHz (QEMU default)
        mmio_write(UART_IBRD, 13);
        mmio_write(UART_FBRD, 2);

        // 8N1, FIFO enabled
        mmio_write(UART_LCRH, (1 << 4) | (1 << 5) | (1 << 6));

        // Enable UART, TX, RX
        mmio_write(UART_CR, (1 << 0) | (1 << 8) | (1 << 9));
    }
    // Disable UART
}

pub unsafe fn uart_write_byte(c: u8) {
    // Tunggu sampai TX FIFO tidak penuh
    while unsafe { mmio_read(UART_FR) & (1 << 5) != 0 } {}

    unsafe {
        mmio_write(UART_DR, c as u32);
    }
}

pub unsafe fn uart_write_str(s: &str) {
    for b in s.bytes() {
        if b == b'\n' {
            unsafe {
                uart_write_byte(b'\r');
            }
        }
        unsafe {
            uart_write_byte(b);
        }
    }
}
