# PhoneUnlocker - macOS Screensaver Unlock via iPhone

A secure and intuitive macOS application that uses your iPhone's Face ID to unlock your Mac's screensaver. Uses PassKit (Apple Pay) to initiate authentication with a $0 transaction.

## Features

✨ **Face ID Authentication** - Unlock your Mac using Face ID on your iPhone
💰 **Zero-Dollar Transactions** - Uses Apple Pay's $0 transaction to trigger authentication
🔐 **Secure** - Leverages PassKit framework for enterprise-grade security
🎯 **Simple UI** - Clean, intuitive menu bar application
⚡ **Lightweight** - Minimal system resource usage
🚀 **Fast** - Sub-second authentication response

## Requirements

- **macOS 13.0** or later (Ventura or newer)
- **Apple Pay** configured on your device
- **iPhone** with Face ID enabled
- **Xcode 14** or later (for building from source)
- Administrator access for installation

## Quick Start

### Automatic Installation

```bash
cd /path/to/macOS-phone-unlock
bash Installer/install.sh
```

The installation script will:
1. Check system requirements
2. Build the application from source
3. Install to `/Applications`
4. Request necessary permissions
5. Optionally launch the app

### Manual Installation

1. **Clone or download the repository**
   ```bash
   git clone https://github.com/maksimvialykh/macOS-phone-unlock.git
   cd macOS-phone-unlock
   ```

2. **Open in Xcode**
   ```bash
   open PhoneUnlocker/PhoneUnlocker.xcodeproj
   ```

3. **Build the project**
   - Select `PhoneUnlocker` as the target
   - Select `Product` → `Build` (⌘B)
   - Select `Product` → `Archive`
   - Export the app to `/Applications`

4. **Grant permissions** (see below)

## Setup Instructions

### Step 1: Install Apple Pay
1. Open **System Preferences** → **Wallet & Apple Pay**
2. Add a valid payment card if you haven't already
3. Verify your payment method is active

### Step 2: Grant Accessibility Permissions
1. Open **System Preferences** → **Security & Privacy** → **Accessibility**
2. Click the lock 🔒 to make changes (enter your password if needed)
3. Click the **+** button and add `PhoneUnlocker.app` from `/Applications`
4. Allow the application

### Step 3: Initial Configuration
1. Launch **PhoneUnlocker** from Applications or Spotlight Search (⌘Space)
2. The app runs in the menu bar (top-right corner)
3. Verify "Screensaver Status" shows as "Inactive"

## How to Use

### Unlock Your Screensaver

1. **Your Mac screensaver activates** (after your idle timeout)
2. **Click the PhoneUnlocker menu bar icon** ☰
3. **Click "Verify with iPhone"** button
4. **Face ID prompt appears on your iPhone**
5. **Authenticate with Face ID on your phone**
6. **Your Mac screensaver unlocks instantly**

### Real-World Scenarios

**At Your Desk:**
- Step away from Mac → Screensaver activates
- Come back, check your iPhone for notification
- Tap to verify with Face ID
- Your Mac is instantly unlocked

**Presentation Mode:**
- No need to type password on public display
- Just use Face ID privately on your phone
- Maintains security and privacy

**Security:**
- Mac stays locked when you're away
- Only you can unlock (requires Face ID)
- Zero-dollar transactions leave no trace

## Project Structure

```
macOS-phone-unlock/
├── PhoneUnlocker/                    # Main application
│   ├── PhoneUnlocker/               # Swift source code
│   │   ├── PhoneUnlockerApp.swift   # App entry point
│   │   ├── ContentView.swift        # UI and main logic
│   │   ├── ApplePayController.swift # PassKit integration
│   │   ├── ScreensaverManager.swift # Screensaver detection & control
│   │   ├── Assets.xcassets          # App icons and assets
│   │   ├── Info.plist               # Bundle configuration
│   │   └── PhoneUnlocker.entitlements # Required permissions
│   └── PhoneUnlocker.xcodeproj      # Xcode project
├── Installer/                        # Installation scripts
│   ├── install.sh                   # Automated installer
│   └── uninstall.sh                 # Uninstaller
├── Docs/                            # Documentation
└── README.md                        # This file
```

## Technical Details

### PassKit Integration
- Uses `PKPaymentRequest` to create a zero-dollar payment request
- Triggers `PKPaymentAuthorizationViewController` UI on macOS
- iPhone receives authentication request and prompts Face ID
- Zero-dollar amount ensures no actual charges

### Screensaver Detection
- Monitors system idle time via IOKit
- Detects screensaver activation state
- Uses CGEvent for mouse and keyboard simulation
- Securely unlocks without bypassing security

### Security Features
- ✅ Requires Face ID (biometric authentication)
- ✅ No passwords stored locally
- ✅ Uses Apple's PassKit framework
- ✅ Supports Apple's Hardened Runtime
- ✅ Minimal system permissions required

## Troubleshooting

### App Won't Launch
```bash
# Check system logs
log stream --predicate 'process == "PhoneUnlocker"'

# Verify permissions
ls -la /Applications/PhoneUnlocker.app
```

### Apple Pay Not Available
- Ensure Apple Pay is configured in System Preferences
- Add a valid payment method to Wallet
- Restart the app after changing payment settings

### Face ID Not Triggering
1. Check iPhone is nearby and has network connectivity
2. Ensure iPhone has Face ID enabled
3. Verify WiFi or Bluetooth connection is active
4. Check System Preferences → Security & Privacy → Accessibility includes PhoneUnlocker

### Screensaver Not Unlocking
1. Verify screensaver is actually active (check System Preferences)
2. Grant accessibility permissions (see Setup Step 2)
3. Check "Screensaver Status" in the app shows "Active"
4. Try the "Verify with iPhone" button manually

### Build Errors
```bash
# Clean and rebuild
cd PhoneUnlocker
xcodebuild clean
xcodebuild -scheme PhoneUnlocker -configuration Release

# Or use Xcode GUI
# Shift + ⌘ + K to clean
# ⌘ + B to rebuild
```

## Uninstallation

### Using the uninstaller script:
```bash
bash Installer/uninstall.sh
```

### Manual removal:
```bash
rm -rf /Applications/PhoneUnlocker.app

# Remove from Accessibility permissions
# System Preferences → Security & Privacy → Accessibility → Remove PhoneUnlocker
```

## Advanced Configuration

### Custom Idle Timeout
Edit [ScreensaverManager.swift](PhoneUnlocker/PhoneUnlocker/ScreensaverManager.swift):
```swift
private func getScreensaverTimeout() -> TimeInterval {
    return 300  // Change this value (in seconds)
}
```

### Merchant Identifier
To use with real Apple Pay (not recommended for this use case):
1. Configure Apple Developer account
2. Update `merchantIdentifier` in [ApplePayController.swift](PhoneUnlocker/PhoneUnlocker/ApplePayController.swift)
3. Set up payment processing backend

## Privacy & Security

- ✅ **No data collection** - App doesn't collect or send any data
- ✅ **Local only** - All processing happens on your Mac
- ✅ **Open source** - Code is transparent and auditable
- ✅ **No tracking** - No analytics or telemetry
- ✅ **Uses PassKit** - Apple's native, secure payment framework

## Development

### Building from Source
```bash
# Clone repository
git clone https://github.com/maksimvialykh/macOS-phone-unlock.git
cd macOS-phone-unlock/PhoneUnlocker

# Build
xcodebuild -scheme PhoneUnlocker -configuration Release

# Or open in Xcode
open PhoneUnlocker.xcodeproj
```

### Key Files
- [PhoneUnlockerApp.swift](PhoneUnlocker/PhoneUnlocker/PhoneUnlockerApp.swift) - App initialization
- [ContentView.swift](PhoneUnlocker/PhoneUnlocker/ContentView.swift) - UI implementation
- [ApplePayController.swift](PhoneUnlocker/PhoneUnlocker/ApplePayController.swift) - PassKit logic
- [ScreensaverManager.swift](PhoneUnlocker/PhoneUnlocker/ScreensaverManager.swift) - Screensaver control

### Contributing
Contributions are welcome! Please feel free to submit pull requests.

## Limitations

- **Requires Face ID** - Only works with iPhones that have Face ID
- **Requires Apple Pay** - Must have Apple Pay configured
- **macOS 13+** - Requires recent macOS version
- **Network dependent** - Needs WiFi or Bluetooth connectivity
- **Menu bar only** - Runs as menu bar application

## Known Issues

- Zero-dollar transactions may appear in Apple Pay history
- Requires re-authentication after each unlock (security feature)
- Works with T2 Mac and Apple Silicon only (for maximum compatibility)

## License

MIT License - See [LICENSE](LICENSE) file for details

## Support

- 📧 Email: support@phoneunlocker.dev
- 🐛 Issues: [GitHub Issues](https://github.com/maksimvialykh/macOS-phone-unlock/issues)
- 💬 Discussions: [GitHub Discussions](https://github.com/maksimvialykh/macOS-phone-unlock/discussions)

## Acknowledgments

- Apple PassKit Framework
- SwiftUI for modern UI
- macOS IOKit for system integration

---

**PhoneUnlocker v1.0** | Made with ❤️ for Mac users
