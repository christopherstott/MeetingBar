import AppKit

struct ScreenSharing {
    public static var isActive: Bool {
        // Check if any screen is being captured
        let session = CGWindowListCopyWindowInfo([.optionOnScreenOnly], kCGNullWindowID) as? [[String: Any]] ?? []
        
        // Look for screen recording/sharing windows
        return session.contains { window in
            let name = window[kCGWindowName as String] as? String ?? ""
            let owner = window[kCGWindowOwnerName as String] as? String ?? ""
            
            // Common screen sharing/recording app identifiers
            return owner.contains("zoom.us") ||
                   owner.contains("Skype") ||
                   owner.contains("Microsoft Teams") ||
                   owner.contains("Screen Sharing") ||
                   owner.contains("Screen Recording") ||
                   name.contains("Screen Recording") ||
                   name.contains("Screen Sharing")
        }
    }
} 
