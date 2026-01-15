# 🎯 PhoneUnlocker - Quick Reference Card

## Installation
```bash
bash Installer/install.sh
```

## First Time Setup
1. Apple Pay: System Preferences → Wallet & Apple Pay → Add card
2. Permissions: System Preferences → Security & Privacy → Accessibility → Add PhoneUnlocker
3. Launch: Open PhoneUnlocker from Applications

## How to Use
1. Screensaver activates (5 min idle default)
2. Click menu bar icon (top-right corner)
3. Click "Verify with iPhone" button
4. Complete Face ID on iPhone
5. Mac unlocks ✓

## Menu Bar Status
| Icon | Meaning |
|------|---------|
| 🟢 Inactive | Screensaver is off |
| 🔴 Active | Screensaver is on (ready to unlock) |

## Troubleshooting Quick Fixes

### "Apple Pay not available"
```
System Preferences → Wallet & Apple Pay → Add payment card
```

### "Accessibility permission required"
```
System Preferences → Security & Privacy → Accessibility → 
Add /Applications/PhoneUnlocker.app
```

### "Face ID not working"
```
1. Check iPhone and Mac on same WiFi
2. Verify Face ID works on iPhone
3. Restart PhoneUnlocker
```

### App won't launch
```bash
/Applications/PhoneUnlocker.app/Contents/MacOS/PhoneUnlocker
```

## System Requirements
- macOS 13.0+ (Ventura or newer)
- Apple Pay configured
- iPhone with Face ID (XS or newer)
- WiFi or Bluetooth connection

## Keyboard Shortcuts (Coming v1.1)
- ⌘⌥U - Quick unlock (planned)
- ⌘⌥S - Open settings (planned)

## File Locations
- App: `/Applications/PhoneUnlocker.app`
- Preferences: `~/Library/Preferences/com.phoneunlocker.*`
- Logs: `~/Library/Logs/PhoneUnlocker/`

## Useful Commands

### Restart the app
```bash
killall PhoneUnlocker
open -a PhoneUnlocker
```

### View logs
```bash
log stream --predicate 'process == "PhoneUnlocker"'
```

### Uninstall
```bash
bash Installer/uninstall.sh
# Or manually:
rm -rf /Applications/PhoneUnlocker.app
```

### Build from source
```bash
cd PhoneUnlocker
xcodebuild -scheme PhoneUnlocker -configuration Release
```

## Default Settings
- Screensaver idle timeout: 5 minutes (system default)
- Monitoring interval: 2 seconds
- Unlock timeout: 30 seconds
- Auto-launch: No (can enable in System Preferences)

## Supported Devices

### iPhones (Need Face ID)
- iPhone XS, XS Max, XR
- iPhone 11, 11 Pro, 11 Pro Max
- iPhone 12, 12 mini, 12 Pro, 12 Pro Max
- iPhone 13, 13 mini, 13 Pro, 13 Pro Max
- iPhone 14, 14 Pro, 14 Pro Max
- iPhone 15, 15 Plus, 15 Pro, 15 Pro Max

### Macs (macOS 13+)
- Apple Silicon Macs (M1 and newer)
- Intel Macs with T2 chip
- Both require macOS 13.0 or later

## Common Issues & Solutions

| Problem | Solution |
|---------|----------|
| App won't launch | Check accessibility permissions |
| Face ID not triggering | Ensure WiFi connection |
| Screensaver won't unlock | Verify screensaver is active |
| "Apple Pay" error | Add payment method in Wallet |
| Memory leak | Restart the app |
| High CPU usage | Restart system |

## Documentation Links
- Getting Started: [GETTING_STARTED.md](GETTING_STARTED.md)
- Quick Start: [Docs/QUICKSTART.md](Docs/QUICKSTART.md)
- Installation: [Docs/INSTALLATION.md](Docs/INSTALLATION.md)
- Troubleshooting: [Docs/TROUBLESHOOTING.md](Docs/TROUBLESHOOTING.md)
- Full Docs: [Docs/README.md](Docs/README.md)
- Development: [Docs/DEVELOPMENT.md](Docs/DEVELOPMENT.md)

## Support
- 🐛 Issues: https://github.com/maksimvialykh/macOS-phone-unlock/issues
- 💬 Discussions: https://github.com/maksimvialykh/macOS-phone-unlock/discussions
- 📧 Email: support@phoneunlocker.dev

## Version Info
- **Current:** v1.0.0
- **Status:** Production Ready
- **License:** MIT Open Source
- **Updated:** January 15, 2026

---

**Quick reminder: Your Mac + iPhone Face ID = Zero-password unlocking!** 🔓
