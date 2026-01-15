# PhoneUnlocker Installer Quick Start

## 🚀 Quick Build

### Build the complete installer (PKG + DMG)

```bash
cd /Users/maksimvialykh/github/macOS-phone-unlock
./Installer/build-all.sh
```

**Output:**
- ✅ `Installer/output/PhoneUnlocker-1.0.0.pkg` (direct installer)
- ✅ `Installer/output/PhoneUnlocker-1.0.0.dmg` (distribution package)

### What happens during build:

1. ✅ Verifies Xcode is installed
2. ✅ Builds PhoneUnlocker app in Release mode
3. ✅ Creates component package with pre/post-install scripts
4. ✅ Creates distribution package with UI screens
5. ✅ Creates DMG disk image for sharing

## 📦 Installation Methods

### For Users: Double-Click PKG or DMG
```
1. Find PhoneUnlocker-1.0.0.pkg (or DMG)
2. Double-click to open installer
3. Follow on-screen instructions
4. Grant accessibility permissions
5. Done! App is in Applications folder
```

### For Developers: Command Line
```bash
installer -pkg Installer/output/PhoneUnlocker-1.0.0.pkg -target /
```

## 🔐 Optional: Code Sign & Notarize

### Code Sign Package
```bash
codesign -s "Developer ID Installer: Your Name" \
    Installer/output/PhoneUnlocker-1.0.0.pkg
```

### Notarize for Distribution
```bash
xcrun altool --notarize-app \
    -f Installer/output/PhoneUnlocker-1.0.0.dmg \
    --primary-bundle-id com.phoneunlocker.app
```

## 📋 Build Scripts Explained

| Script | Purpose | Usage |
|--------|---------|-------|
| `build-pkg.sh` | Creates installer package | `./Installer/build-pkg.sh` |
| `build-dmg.sh` | Creates disk image | `./Installer/build-dmg.sh` |
| `build-all.sh` | Builds both PKG + DMG | `./Installer/build-all.sh` |

## 🎯 Installer Features

- ✅ **Pre-Installation Checks**
  - Verifies macOS 13.0+
  - Checks available disk space
  - Terminates existing processes
  
- ✅ **User-Friendly Interface**
  - Welcome screen with features
  - Installation guide
  - License agreement
  
- ✅ **Post-Installation Setup**
  - Correct file permissions
  - Accessibility database updates
  - Automatic configuration
  
- ✅ **Error Handling**
  - Validates system requirements
  - Creates installation backups
  - Comprehensive logging

## 🔍 Verify Installation

After building, verify the package:

```bash
# Check PKG structure
pkgutil --info Installer/output/PhoneUnlocker-1.0.0.pkg

# Check package contents
pkgutil --expand Installer/output/PhoneUnlocker-1.0.0.pkg /tmp/expanded
ls -la /tmp/expanded
```

## 🐛 Troubleshooting

### Build fails - "Xcode not found"
```bash
xcode-select --install
```

### Build fails - "pkgbuild not found"
```bash
sudo xcode-select --reset
```

### Scripts not executable
```bash
chmod +x Installer/build-*.sh
chmod +x Installer/scripts/preinstall
chmod +x Installer/scripts/postinstall
```

### Installation blocked by Gatekeeper
1. Hold Control and click the .pkg
2. Select "Open"
3. Click "Open" in security dialog

Or:
```bash
sudo spctl --master-disable  # Disable check
# ... install package ...
sudo spctl --master-enable   # Re-enable check
```

## 📚 Full Documentation

For complete details, see [INSTALLER_GUIDE.md](INSTALLER_GUIDE.md)

---

**Ready to build?** Run: `./Installer/build-all.sh`
