# PhoneUnlocker Installer

Professional macOS PKG installer for PhoneUnlocker application.

## 📦 What's Inside

This directory contains everything needed to build and distribute PhoneUnlocker:

### Build Scripts
- **`build-pkg.sh`** - Creates the complete PKG installer
- **`build-dmg.sh`** - Creates a DMG disk image for sharing
- **`build-all.sh`** - Master script (builds both PKG and DMG)

### Installation Scripts
- **`scripts/preinstall`** - Pre-installation validation and setup
- **`scripts/postinstall`** - Post-installation configuration

### Distribution Configuration
- **`distribution/Distribution.xml`** - PKG installer configuration
- **`distribution/Welcome.html`** - Installation welcome screen
- **`distribution/Readme.html`** - Installation guide
- **`distribution/License.html`** - MIT License display

## 🚀 Getting Started

### Prerequisites
```bash
# Verify Xcode is installed
xcode-select --print-path

# Install if needed
xcode-select --install
```

### Build the Installer

**One command to build everything:**
```bash
./build-all.sh
```

**Or build individually:**
```bash
./build-pkg.sh    # Creates PhoneUnlocker-1.0.0.pkg
./build-dmg.sh    # Creates PhoneUnlocker-1.0.0.dmg
```

### Output Files

After building, find your installer in:
```
output/
├── PhoneUnlocker-1.0.0.pkg      (Direct installer)
└── PhoneUnlocker-1.0.0.dmg      (Distribution package)
```

## 📖 Documentation

- **[Installer Quick Start](../INSTALLER_QUICKSTART.md)** - Fast overview
- **[Installer Guide](../INSTALLER_GUIDE.md)** - Complete documentation
- **[README](../README.md)** - Main project documentation

## 🎯 Installation Experience for Users

### When users double-click the installer:

1. **Welcome Screen** displays:
   - Product overview
   - System requirements
   - What's included

2. **Pre-Installation Checks** verify:
   - macOS 13.0 or later
   - Sufficient disk space
   - No conflicting processes

3. **Installation Progress**:
   - Extracts application
   - Copies to Applications folder
   - Configures system permissions

4. **Post-Installation Setup**:
   - Updates accessibility database
   - Sets correct file permissions
   - Prepares for first launch

5. **Success Message** shows:
   - Installation completion
   - Next steps
   - How to launch the app

## 🔑 Key Features

✅ **Professional UI** - HTML-based installation wizard  
✅ **System Validation** - Ensures compatibility  
✅ **Error Recovery** - Creates backups automatically  
✅ **Logging** - Records all installation events  
✅ **Permissions** - Automatic accessibility setup  
✅ **Security** - Proper file permissions configuration  

## 🐛 Troubleshooting

### Build fails - "command not found"
```bash
# Make scripts executable
chmod +x build-*.sh
chmod +x scripts/preinstall
chmod +x scripts/postinstall
```

### Build fails - "Xcode not found"
```bash
xcode-select --install
```

### Installation blocked by Gatekeeper
Right-click the .pkg file and select "Open"

### Permissions not working
Users should check System Preferences → Security & Privacy → Accessibility

## 📋 Build Process

```
Input:                 PhoneUnlocker Source Code
                              ↓
build-pkg.sh    ──→   Xcode Build
                              ↓
                       Component .pkg
                              ↓
                       Distribution .pkg
                              ↓
Output:                PhoneUnlocker-1.0.0.pkg
                              ↓
build-dmg.sh    ──→   DMG Wrapper
                              ↓
Output:                PhoneUnlocker-1.0.0.dmg
```

## 📦 Distribution

### For Public Release

1. **Build:**
   ```bash
   ./build-all.sh
   ```

2. **Code Sign (optional but recommended):**
   ```bash
   codesign -s "Developer ID Installer: Your Name" \
       output/PhoneUnlocker-1.0.0.pkg
   ```

3. **Notarize (optional):**
   ```bash
   xcrun altool --notarize-app \
       -f output/PhoneUnlocker-1.0.0.dmg \
       --primary-bundle-id com.phoneunlocker.app
   ```

4. **Distribute:** Share the DMG file

### For Testing

```bash
# Mount and test the DMG
open output/PhoneUnlocker-1.0.0.dmg
```

## 🔗 Quick Links

- [Build all scripts](./build-all.sh)
- [Installation guide](../INSTALLER_GUIDE.md)
- [Main README](../README.md)
- [Project home](../)

---

**Version:** 1.0.0  
**Last Updated:** 2024
