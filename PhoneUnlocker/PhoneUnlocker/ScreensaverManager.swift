import Foundation
import ScreenTime
import IOKit.pwr_mgt

class ScreensaverManager: ObservableObject {
    @Published var isActive = false
    
    private var displayLink: CVDisplayLink?
    private var timer: Timer?
    
    init() {
        startMonitoring()
    }
    
    deinit {
        stopMonitoring()
    }
    
    /// Monitor screensaver state
    private func startMonitoring() {
        // Check screensaver status every 2 seconds
        timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { [weak self] _ in
            self?.updateScreensaverStatus()
        }
    }
    
    private func stopMonitoring() {
        timer?.invalidate()
        timer = nil
    }
    
    private func updateScreensaverStatus() {
        // Check if screensaver is active by looking at system idle time
        let idleTime = getSystemIdleTime()
        let screensaverTimeout = getScreensaverTimeout()
        
        DispatchQueue.main.async {
            self.isActive = idleTime > screensaverTimeout
        }
    }
    
    /// Get system idle time in seconds
    private func getSystemIdleTime() -> TimeInterval {
        var lastEventTime = io_registry_entry_t()
        if #available(macOS 10.1, *) {
            let service = IOServiceGetMatchingService(
                kIOMainPortDefault,
                IOServiceMatching("IOHIDSystem")
            )
            
            if service != 0 {
                if let properties = IORegistryEntryCreateCFProperty(
                    service,
                    "HIDIdleTime" as CFString,
                    kCFAllocatorDefault,
                    0
                ).takeRetainedValue() as? Int {
                    IOObjectRelease(service)
                    return TimeInterval(properties) / 1_000_000_000 // Convert nanoseconds to seconds
                }
                IOObjectRelease(service)
            }
        }
        return 0
    }
    
    /// Get screensaver timeout in seconds (default 5 minutes)
    private func getScreensaverTimeout() -> TimeInterval {
        let defaults = UserDefaults.standard
        if let timeout = defaults.object(forKey: "com.apple.screensaver.askForPassword") {
            return 300 // 5 minutes default
        }
        return 300
    }
    
    /// Unlock the screensaver by moving the mouse and simulating key press
    func unlockScreensaver() async throws {
        // Get current mouse position
        let currentMousePos = NSEvent.mouseLocation
        
        // Move mouse slightly to wake the screen
        let movePos = CGPoint(
            x: currentMousePos.x + 10,
            y: currentMousePos.y + 10
        )
        
        let moveEvent = CGEvent(
            mouseEventSource: nil,
            mouseType: .mouseMoved,
            mouseCursorPosition: movePos,
            timestamp: 0
        )
        moveEvent?.post(tap: .cghidEventTap)
        
        // Wait a moment
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
        
        // Simulate spacebar press to dismiss screensaver or login window
        let keyDown = CGEvent(keyboardEventSource: nil, virtualKey: 49, keyDown: true)
        let keyUp = CGEvent(keyboardEventSource: nil, virtualKey: 49, keyDown: false)
        
        keyDown?.post(tap: .cghidEventTap)
        try await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
        keyUp?.post(tap: .cghidEventTap)
        
        // Move mouse back to original position
        let backEvent = CGEvent(
            mouseEventSource: nil,
            mouseType: .mouseMoved,
            mouseCursorPosition: currentMousePos,
            timestamp: 0
        )
        backEvent?.post(tap: .cghidEventTap)
        
        // Update status
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.updateScreensaverStatus()
        }
    }
}
