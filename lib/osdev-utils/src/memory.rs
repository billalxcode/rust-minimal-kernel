//! Memory management utilities

/// Align address up to the given alignment
pub const fn align_up(addr: usize, align: usize) -> usize {
    (addr + align - 1) & !(align - 1)
}

/// Align address down to the given alignment  
pub const fn align_down(addr: usize, align: usize) -> usize {
    addr & !(align - 1)
}

/// Check if address is aligned
pub const fn is_aligned(addr: usize, align: usize) -> bool {
    addr & (align - 1) == 0
}

/// Convert bytes to pages (4KB pages)
pub const fn bytes_to_pages(bytes: usize) -> usize {
    align_up(bytes, 4096) / 4096
}

/// Convert pages to bytes (4KB pages)
pub const fn pages_to_bytes(pages: usize) -> usize {
    pages * 4096
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_align_up() {
        assert_eq!(align_up(0, 4096), 0);
        assert_eq!(align_up(1, 4096), 4096);
        assert_eq!(align_up(4096, 4096), 4096);
        assert_eq!(align_up(4097, 4096), 8192);
    }

    #[test]
    fn test_align_down() {
        assert_eq!(align_down(0, 4096), 0);
        assert_eq!(align_down(4095, 4096), 0);
        assert_eq!(align_down(4096, 4096), 4096);
        assert_eq!(align_down(8191, 4096), 4096);
    }
}