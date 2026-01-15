# Development Guide

Guide for developers who want to contribute to or modify PhoneUnlocker.

## Setup for Development

### Prerequisites

```bash
# Xcode 14 or later
xcode-select --install

# Verify Xcode
xcodebuild -version
```

### Clone Repository

```bash
git clone https://github.com/maksimvialykh/macOS-phone-unlock.git
cd macOS-phone-unlock
```

### Open in Xcode

```bash
open PhoneUnlocker/PhoneUnlocker.xcodeproj
```

## Project Structure

### Source Files

```
PhoneUnlocker/PhoneUnlocker/
├── PhoneUnlockerApp.swift       # SwiftUI App entry point
├── ContentView.swift            # Main UI (menu bar)
├── ApplePayController.swift     # PassKit integration
└── ScreensaverManager.swift     # System interaction
```

### Configuration Files

```
PhoneUnlocker/
├── PhoneUnlocker.xcodeproj      # Xcode project
├── Info.plist                   # Bundle configuration
└── PhoneUnlocker.entitlements   # System permissions
```

## Key Classes

### `ApplePayController`

Handles Apple Pay / PassKit integration.

**Key Methods:**
- `initiateZeroTransaction()` - Creates and presents payment sheet
- `paymentAuthorizationViewControllerDidFinish()` - Handles payment completion
- `paymentAuthorizationViewController(_:didAuthorizePayment:handler:)` - Processes Face ID result

**Key Properties:**
- `isProcessing: Bool` - Current processing state
- `continuation: CheckedContinuation<Void, Error>` - Async/await handling

### `ScreensaverManager`

Monitors and controls screensaver state.

**Key Methods:**
- `startMonitoring()` - Begins idle time monitoring
- `updateScreensaverStatus()` - Checks current screensaver state
- `unlockScreensaver()` - Simulates mouse movement and key press
- `getSystemIdleTime()` - Queries IOKit for idle time
- `getScreensaverTimeout()` - Gets screensaver activation time

**Key Properties:**
- `isActive: @Published` - Current screensaver state
- `timer: Timer?` - Monitoring timer reference

### `ContentView`

SwiftUI UI implementation.

**Key Sections:**
- Status display (screensaver state)
- Action button (initiates authentication)
- Error/success messages
- Settings shortcuts

## Common Development Tasks

### Adding a New Feature

1. **Create a new file:**
   ```bash
   touch PhoneUnlocker/PhoneUnlocker/MyNewFeature.swift
   ```

2. **Add to Xcode project:**
   - Drag file into Xcode navigator
   - Ensure target is set to `PhoneUnlocker`

3. **Add to build phases:**
   - If file isn't automatically included:
   - Project → Target → Build Phases → Compile Sources
   - Click **+** and add your file

4. **Rebuild:**
   ```bash
   xcodebuild -scheme PhoneUnlocker -configuration Release
   ```

### Modifying the UI

All UI changes are in `ContentView.swift`:

```swift
// Example: Add a button
Button(action: {
    print("Button tapped!")
}) {
    Label("My Button", systemImage: "star")
}
```

### Changing Screensaver Idle Time

Edit `ScreensaverManager.swift`:

```swift
private func getScreensaverTimeout() -> TimeInterval {
    return 300  // Change this (in seconds)
    // Example: 600 = 10 minutes
}
```

### Adjusting Monitoring Frequency

```swift
// In ScreensaverManager.startMonitoring():
timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { [weak self] _ in
    // Change 2.0 to desired interval in seconds
    self?.updateScreensaverStatus()
}
```

## Building and Testing

### Debug Build

```bash
xcodebuild -scheme PhoneUnlocker -configuration Debug
```

### Release Build

```bash
xcodebuild -scheme PhoneUnlocker -configuration Release
```

### Run from Terminal

```bash
# Debug
/path/to/build/Debug/PhoneUnlocker.app/Contents/MacOS/PhoneUnlocker

# Release
/path/to/build/Release/PhoneUnlocker.app/Contents/MacOS/PhoneUnlocker
```

### View Logs

```bash
# Real-time logs
log stream --predicate 'process == "PhoneUnlocker"' --level debug

# Historical logs
log show --predicate 'process == "PhoneUnlocker"' --last 24h
```

## Code Style

### Swift Conventions

- Use **camelCase** for variables and functions
- Use **PascalCase** for classes and types
- Use **UPPERCASE** for constants
- Maximum line length: 100 characters
- Use meaningful variable names

### Example:

```swift
class MyController: ObservableObject {
    @Published var isProcessing = false
    private let timeoutInterval: TimeInterval = 30.0
    
    private func myPrivateMethod() {
        // Implementation
    }
    
    func myPublicMethod() async throws {
        // Implementation
    }
}
```

## Testing

### Manual Testing Checklist

- [ ] App launches without errors
- [ ] Menu bar icon appears
- [ ] "Verify with iPhone" button responds
- [ ] Face ID prompt appears on iPhone
- [ ] Successful authentication unlocks screensaver
- [ ] Error messages display correctly
- [ ] Settings links open properly

### Device Testing

```bash
# Build for specific macOS version
xcodebuild -scheme PhoneUnlocker -destination 'generic/platform=macOS'

# Test on macOS 13 (Ventura) or later
```

## Troubleshooting Development

### Build Errors

**"PassKit.framework not found"**
```bash
# Ensure framework is linked
xcode-select --install
```

**"Command not found: xcodebuild"**
```bash
# Install Command Line Tools
xcode-select --install
```

**Linker errors**
```bash
# Clean and rebuild
rm -rf build/
xcodebuild clean
xcodebuild -scheme PhoneUnlocker -configuration Release
```

### Runtime Errors

**Screensaver unlock not working:**
- Check Accessibility permissions granted
- Verify IOKit access via logs

**Face ID not triggering:**
- Ensure Apple Pay configured
- Check network connectivity
- Verify device settings

### Debugging

**Print debugging:**
```swift
print("Debug: \(value)")
os_log("Debug message: %@", log: OSLog.default, type: .debug, value)
```

**LLDB commands:**
```bash
# Pause execution
(lldb) br s -n "myMethod"

# Print variable
(lldb) po variableName

# Continue execution
(lldb) c
```

## Contributing Guidelines

1. **Fork the repository**
   ```bash
   git clone https://github.com/YOUR_USERNAME/macOS-phone-unlock.git
   ```

2. **Create feature branch**
   ```bash
   git checkout -b feature/my-feature
   ```

3. **Make changes**
   - Keep commits small and focused
   - Write descriptive commit messages

4. **Test thoroughly**
   - Run full build: `xcodebuild -scheme PhoneUnlocker -configuration Release`
   - Test on macOS 13+ 
   - Test with Face ID

5. **Push and create PR**
   ```bash
   git push origin feature/my-feature
   ```

## Architecture

### MVVM Pattern

```
View (SwiftUI) → ViewModel (ObservableObject) → Model (Core Logic)
    ContentView      ApplePayController         PassKit Integration
                     ScreensaverManager         System APIs
```

### Data Flow

```
User clicks button
    ↓
ContentView.initiatePhoneAuth()
    ↓
ApplePayController.initiateZeroTransaction()
    ↓
PassKit shows payment sheet
    ↓
iPhone receives auth request
    ↓
User completes Face ID
    ↓
ApplePayController receives result
    ↓
ScreensaverManager.unlockScreensaver()
    ↓
Screensaver releases
```

## Performance Optimization

### Memory Usage

- Monitor in Activity Monitor
- Check for memory leaks using Instruments

### CPU Usage

```swift
// Reduce polling frequency if needed
timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { [weak self] _ in
    self?.updateScreensaverStatus()
}
```

### Battery Life

- Minimize background monitoring
- Use Timer instead of while loops
- Clean up resources in `deinit`

## Release Process

### Prepare Release

1. Update version in `Info.plist`
2. Update `CHANGELOG`
3. Test thoroughly
4. Tag release: `git tag v1.0.0`

### Build Release

```bash
xcodebuild -scheme PhoneUnlocker -configuration Release -derivedDataPath build archive
```

### Sign and Distribute

(Requires Apple Developer account for distribution)

## Resources

- [Apple PassKit Documentation](https://developer.apple.com/documentation/passkit)
- [SwiftUI Documentation](https://developer.apple.com/xcode/swiftui/)
- [macOS Development Guide](https://developer.apple.com/macos/resources/)
- [IOKit Framework](https://developer.apple.com/documentation/iokit)

## Support for Development

- 💬 **Discussions:** [GitHub Discussions](https://github.com/maksimvialykh/macOS-phone-unlock/discussions)
- 🐛 **Issues:** [GitHub Issues](https://github.com/maksimvialykh/macOS-phone-unlock/issues)
- 📧 **Email:** dev@phoneunlocker.dev

---

**Happy developing!** 🚀
