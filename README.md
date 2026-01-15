# PhoneUnlocker - macOS Screensaver Unlock via iPhone Face ID

A secure, intuitive macOS application that uses your iPhone's Face ID to unlock your Mac's screensaver. Leverages PassKit (Apple Pay) with a $0 transaction to trigger biometric authentication.

## 🎯 Key Features

- **Face ID Authentication** - Unlock screensaver using iPhone Face ID
- **Zero-Dollar Transaction** - Uses Apple Pay $0 transaction (no charges)
- **Enterprise Security** - Built with PassKit framework for maximum security
- **Menu Bar Application** - Clean, minimal UI in your menu bar
- **Lightweight** - Minimal system resource usage
- **Instant Unlock** - Sub-second authentication response
- **Privacy-First** - No data collection, all processing local

## 🚀 Quick Start

### Installation (PKG Installer)

For most users, the easiest way is to use the professional macOS installer:

```bash
# Build the installer
./Installer/build-all.sh

# Then double-click the generated installer:
# Installer/output/PhoneUnlocker-1.0.0.pkg
```

The installer handles everything:
- ✅ System requirements check (macOS 13.0+)
- ✅ Pre-installation validation
- ✅ Application installation to /Applications
- ✅ Permission setup with beautiful wizard
- ✅ Post-installation configuration
- ✅ User-friendly UI screens

**Or use the legacy bash installer:**
```bash
bash Installer/install.sh
```

📖 **Full installer guide:** [INSTALLER_QUICKSTART.md](INSTALLER_QUICKSTART.md)

### First Use
1. **Activate screensaver** (or let it activate automatically)
2. **Click menu bar icon** (top-right corner)
3. **Click "Verify with iPhone"**
4. **Confirm with Face ID** on your iPhone
5. **Mac unlocks instantly** ✓

## 📋 Requirements

- macOS 13.0+ (Ventura or newer)
- Apple Pay configured with payment method
- iPhone with Face ID (XS/11/12/13/14/15 series)
- Administrator access for installation
- WiFi or Bluetooth connectivity

## 📚 Documentation

- **[Full README](Docs/README.md)** - Complete feature documentation
- **[Installation Guide](Docs/INSTALLATION.md)** - Detailed setup instructions
- **[Quick Start](Docs/QUICKSTART.md)** - Get running in 5 minutes
- **[Troubleshooting](Docs/TROUBLESHOOTING.md)** - Solutions for common issues

## 🏗️ Project Structure

```
PhoneUnlocker/
├── PhoneUnlocker/              # Main Swift application
│   ├── PhoneUnlockerApp.swift  # App entry point
│   ├── ContentView.swift       # UI implementation
│   ├── ApplePayController.swift# PassKit integration
│   ├── ScreensaverManager.swift# System integration
│   └── Info.plist              # Configuration
├── Installer/                  # Installation scripts
│   ├── install.sh              # Automated installer
│   └── uninstall.sh            # Uninstaller
└── Docs/                       # Documentation
    ├── README.md               # Full documentation
    ├── INSTALLATION.md         # Setup guide
    ├── QUICKSTART.md          # 5-minute guide
    └── TROUBLESHOOTING.md     # Problem solutions
```

## 🛠️ Building from Source

### Prerequisites
- Xcode 14+ installed
- Command Line Tools: `xcode-select --install`

### Build Steps
```bash
cd PhoneUnlocker
xcodebuild -scheme PhoneUnlocker -configuration Release
```

Or open in Xcode:
```bash
open PhoneUnlocker.xcodeproj
```

## 🔐 Security

✅ **Biometric** - Face ID required for authentication  
✅ **No Passwords** - Uses secure PassKit framework  
✅ **No Data** - Processes everything locally  
✅ **Open Source** - Code is transparent and auditable  
✅ **Hardened** - macOS Hardened Runtime enabled  

## 🆘 Troubleshooting

### "Apple Pay not available"
- Open System Preferences → Wallet & Apple Pay
- Add a valid payment method

### "Accessibility permission required"
- System Preferences → Security & Privacy → Accessibility
- Add PhoneUnlocker to the list

### "Face ID not triggering"
- Ensure iPhone and Mac are connected (WiFi/Bluetooth)
- Verify Face ID works on your iPhone
- Check Apple Pay is configured on iPhone

See [TROUBLESHOOTING.md](Docs/TROUBLESHOOTING.md) for more solutions.

## 📖 How It Works

1. **User initiates unlock** - Clicks menu bar button
2. **PassKit creates request** - Zero-dollar Apple Pay transaction
3. **iPhone receives auth** - Shows Face ID prompt
4. **User authenticates** - Completes Face ID
5. **Mac receives response** - Verifies authentication
6. **Screensaver unlocks** - Using mouse/keyboard simulation

## 🎯 Use Cases

**At Your Desk**
- Screensaver activates → Quick Face ID unlock via iPhone

**Public Presentations**
- No need to unlock Mac with password on display
- Authenticate privately on your phone

**Secure Access**
- Only your Face ID can unlock
- No password or PIN needed
- Automatic timeout protection

## 📦 Uninstall

```bash
bash Installer/uninstall.sh
```

Or manually:
```bash
rm -rf /Applications/PhoneUnlocker.app
```

## 🤝 Contributing

Contributions welcome! Please:
1. Fork the repository
2. Create feature branch
3. Commit changes
4. Push to branch
5. Create Pull Request

## 📜 License

MIT License - See [LICENSE](LICENSE) file

## 🙏 Support

- 🐛 **Issues:** [GitHub Issues](https://github.com/maksimvialykh/macOS-phone-unlock/issues)
- 💬 **Questions:** [GitHub Discussions](https://github.com/maksimvialykh/macOS-phone-unlock/discussions)
- 📧 **Email:** support@phoneunlocker.dev

## ⭐ Acknowledgments

- Apple PassKit Framework
- SwiftUI for modern UI
- macOS IOKit for system integration

---

**PhoneUnlocker v1.0** - Made with ❤️ for Mac users

**Start unlocking securely:** `bash Installer/install.sh`