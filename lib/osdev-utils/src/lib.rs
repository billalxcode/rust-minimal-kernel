#![no_std]

//! OS Development Utilities
//! 
//! This crate provides common utilities for operating system development,
//! including VGA text mode handling, memory management helpers, and more.

pub mod vga;
pub mod memory;

/// Common result type for OS operations
pub type OsResult<T> = Result<T, &'static str>;