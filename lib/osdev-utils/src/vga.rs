//! VGA Text Mode Utilities

/// VGA text mode colors
#[derive(Debug, Clone, Copy)]
#[repr(u8)]
pub enum Color {
    Black = 0,
    Blue = 1,
    Green = 2,
    Cyan = 3,
    Red = 4,
    Magenta = 5,
    Brown = 6,
    LightGray = 7,
    DarkGray = 8,
    LightBlue = 9,
    LightGreen = 10,
    LightCyan = 11,
    LightRed = 12,
    Pink = 13,
    Yellow = 14,
    White = 15,
}

/// VGA color attribute combining foreground and background colors
#[derive(Debug, Clone, Copy)]
#[repr(transparent)]
pub struct ColorCode(u8);

impl ColorCode {
    /// Create a new color code with foreground and background colors
    pub const fn new(foreground: Color, background: Color) -> ColorCode {
        ColorCode((background as u8) << 4 | (foreground as u8))
    }
}

/// VGA text mode writer
pub struct VgaWriter {
    buffer: *mut u8,
}

impl VgaWriter {
    /// Create a new VGA writer
    pub const fn new() -> Self {
        VgaWriter {
            buffer: 0xb8000 as *mut u8,
        }
    }

    /// Clear the screen with the given color
    pub fn clear_screen(&mut self, color: ColorCode) {
        unsafe {
            for i in 0..(80 * 25) {
                *self.buffer.offset(i * 2) = b' ';
                *self.buffer.offset(i * 2 + 1) = color.0;
            }
        }
    }

    /// Write a string at the specified position
    pub fn write_string(&mut self, text: &[u8], row: usize, col: usize, color: ColorCode) {
        let offset = (row * 80 + col) * 2;
        unsafe {
            for (i, &byte) in text.iter().enumerate() {
                if col + i >= 80 { break; }
                *self.buffer.offset((offset + i * 2) as isize) = byte;
                *self.buffer.offset((offset + i * 2 + 1) as isize) = color.0;
            }
        }
    }

    /// Write a string at the specified byte offset
    pub fn write_at_offset(&mut self, text: &[u8], offset: usize, color: ColorCode) {
        unsafe {
            for (i, &byte) in text.iter().enumerate() {
                *self.buffer.offset((offset + i * 2) as isize) = byte;
                *self.buffer.offset((offset + i * 2 + 1) as isize) = color.0;
            }
        }
    }
}