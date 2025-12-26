#![no_std]

//! Custom Bootloader for Rust OS
//! 
//! This crate provides bootloader functionality and multiboot support.

/// Multiboot header structure
#[repr(C, packed)]
pub struct MultibootHeader {
    pub magic: u32,
    pub flags: u32,
    pub checksum: u32,
}

impl MultibootHeader {
    /// Create a new multiboot header
    pub const fn new() -> Self {
        const MAGIC: u32 = 0x1BADB002;
        const FLAGS: u32 = 0x0;
        
        MultibootHeader {
            magic: MAGIC,
            flags: FLAGS,
            checksum: 0u32.wrapping_sub(MAGIC).wrapping_sub(FLAGS),
        }
    }
}

/// Bootloader constants
pub mod constants {
    /// Multiboot magic number
    pub const MULTIBOOT_MAGIC: u32 = 0x1BADB002;
    
    /// Default kernel load address (1MB)
    pub const KERNEL_LOAD_ADDRESS: u32 = 0x100000;
}