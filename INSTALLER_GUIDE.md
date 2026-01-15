# PhoneUnlocker PKG Installer Guide

## Overview

The PhoneUnlocker project includes a professional macOS PKG installer that provides a user-friendly installation experience with built-in validation, post-installation configuration, and helpful guidance screens.

## Installer Components

### 1. **Build Scripts**

#### `build-pkg.sh`
Creates the complete PKG installer package with:
- Xcode build automation
- Component packaging
- Distribution package creation
- System verification

**Usage:**
```bash
./Installer/build-pkg.sh
```

**Output:** `Installer/output/PhoneUnlocker-1.0.0.pkg`

#### `build-dmg.sh`
Creates a disk image wrapper for distribution:
- DMG format for easy sharing
- Optimized compression
- Includes installer + Applications folder link

**Usage:**
```bash
./Installer/build-dmg.sh
```

**Output:** `Installer/output/PhoneUnlocker-1.0.0.dmg`

#### `build-all.sh`
Master script that orchestrates the complete build:
- Builds PKG installer
- Creates DMG distribution
- Ready for public release

**Usage:**
```bash
./Installer/build-all.sh
```

### 2. **Pre-Installation Script**

**File:** `Installer/scripts/preinstall`

Executes before installation to:
- ✅ Verify macOS 13.0 or later
- ✅ Terminate existing PhoneUnlocker processes
- ✅ Create backup of current installation
- ✅ Check disk space availability
- ✅ Log installation attempt

### 3. **Post-Installation Script**

**File:** `Installer/scripts/postinstall`

Executes after installation to:
- ✅ Set correct file permissions
- ✅ Update accessibility database
- ✅ Configure application sandbox
- ✅ Clean up temporary files
- ✅ Verify installation success

### 4. **Distribution Configuration**

**File:** `Installer/distribution/Distribution.xml`

Defines the installer package behavior:
- `<options>`: Installation options and customization
- `<choices>`: Installation choices and configurations
- `<pkg-ref>`: Package references and metadata
- **JavaScript validation** for macOS version compatibility

### 5. **User Interface Screens**

#### Welcome Screen
**File:** `Installer/distribution/Welcome.html`

Displays:
- Product overview
- Key features
- System requirements
- What's new in this version

#### Installation Guide
**File:** `Installer/distribution/Readme.html`

Provides:
- Step-by-step installation instructions
- Post-installation setup guide
- Troubleshooting tips
- How to grant accessibility permissions

#### License Agreement
**File:** `Installer/distribution/License.html`

Shows:
- MIT License text
- License acceptance checkbox
- Legal compliance information

## Build Process Workflow

```
┌─────────────────────┐
│  build-all.sh       │
│  (Master Script)    │
└──────────┬──────────┘
           │
    ┌──────┴──────┐
    ▼             ▼
┌─────────┐   ┌─────────┐
│ build-  │   │ build-  │
│ pkg.sh  │   │ dmg.sh  │
└────┬────┘   └────┬────┘
     │             │
     ├─ Verify     └─ Requires
     │   Xcode       .pkg
     │
     ├─ Build App
     │
     ├─ Create Component
     │   Package
     │
     ├─ Create Distribution
     │   Package
     │
     └─ Output PKG
```

## Building the Installer

### Prerequisites

```bash
# 1. Verify Xcode is installed
xcode-select --print-path

# 2. Ensure Xcode Command Line Tools
xcode-select --install
```

### Build Complete Package

```bash
cd /Users/maksimvialykh/github/macOS-phone-unlock
./Installer/build-all.sh
```

### Build Only PKG

```bash
./Installer/build-pkg.sh
```

### Build Only DMG

```bash
./Installer/build-dmg.sh
```

## Installation Methods

### Method 1: Direct PKG Installation

```bash
# User double-clicks the .pkg file or:
open PhoneUnlocker-1.0.0.pkg
```

### Method 2: Command Line Installation

```bash
installer -pkg PhoneUnlocker-1.0.0.pkg -target /
```

### Method 3: DMG Distribution

1. User downloads and mounts the DMG
2. Double-clicks the included .pkg installer
3. Follows the installation wizard

## User Installation Experience

### Step 1: Installer Welcome
- Displays product overview
- Shows system requirements
- Provides installation summary

### Step 2: Pre-Installation Checks
- Verifies macOS 13.0+
- Checks disk space
- Terminates existing processes

### Step 3: Installation Progress
- Extracts application
- Copies to `/Applications`
- Runs post-installation scripts

### Step 4: Post-Installation Setup
- Configures permissions
- Adds accessibility permissions
- Completes setup

### Step 5: Installation Complete
- Shows success message
- Provides next steps
- Application ready to launch

## Permissions & Security

### Accessibility Database
The post-installation script updates the accessibility database to allow PhoneUnlocker to:
- Monitor system idle time
- Simulate keyboard input
- Control screensaver

### Accessibility Request
First launch will prompt:
```
"PhoneUnlocker" would like to access your 
accessibility features.
```

User must click **Allow** to enable:
- System event monitoring
- Keyboard simulation
- Screensaver control

### File Permissions
Installer sets:
- App bundle: 755 (read/execute for all)
- Executable: 755 (executable for all)
- Contents: 755 (read/execute for all)

## Distribution & Code Signing

### Optional: Code Sign Package

```bash
codesign -s "Developer ID Installer: Your Name" \
    PhoneUnlocker-1.0.0.pkg
```

### Optional: Notarize for Distribution

```bash
xcrun altool --notarize-app \
    -f PhoneUnlocker-1.0.0.dmg \
    --primary-bundle-id com.phoneunlocker.app
```

## Troubleshooting

### Build Fails - Xcode Not Found

```bash
# Install or select Xcode
xcode-select --install
# or
sudo xcode-select --reset
```

### Build Fails - Missing Scripts

```bash
# Ensure scripts are executable
chmod +x Installer/scripts/preinstall
chmod +x Installer/scripts/postinstall
chmod +x Installer/build-*.sh
```

### Installation Blocked - Unidentified Developer

**macOS Gatekeeper** may block unsigned packages:

1. Hold Control and click the .pkg file
2. Select "Open" from the context menu
3. Click "Open" in the security dialog

Or disable temporarily:
```bash
sudo spctl --master-disable  # Disable Gatekeeper
# ... install the package ...
sudo spctl --master-enable   # Re-enable Gatekeeper
```

### Permissions Not Granted After Install

1. Open System Preferences → Security & Privacy
2. Go to "Accessibility" tab
3. Add PhoneUnlocker to the list
4. Grant full access

## Package Contents

```
Output/
├── PhoneUnlocker-1.0.0.pkg
│   ├── Distribution.xml        (Installer configuration)
│   ├── PreInstall            (Pre-installation script)
│   ├── PostInstall           (Post-installation script)
│   └── PhoneUnlocker.app     (Application bundle)
│
└── PhoneUnlocker-1.0.0.dmg
    ├── PhoneUnlocker-1.0.0.pkg
    └── Applications → (link to /Applications)
```

## Building for Updates

When releasing an update:

1. Update version in build scripts
2. Update `Distribution.xml` version
3. Run `build-all.sh`
4. Code sign and notarize
5. Distribute DMG to users

## Files Reference

| File | Purpose |
|------|---------|
| `build-pkg.sh` | Build complete PKG installer |
| `build-dmg.sh` | Create DMG distribution |
| `build-all.sh` | Master build orchestrator |
| `scripts/preinstall` | Pre-installation validation |
| `scripts/postinstall` | Post-installation setup |
| `distribution/Distribution.xml` | PKG configuration |
| `distribution/Welcome.html` | Installer welcome screen |
| `distribution/Readme.html` | Installation guide |
| `distribution/License.html` | License agreement |

## Next Steps

1. **Build the installer:**
   ```bash
   ./Installer/build-all.sh
   ```

2. **Test installation:**
   ```bash
   open Installer/output/PhoneUnlocker-1.0.0.dmg
   ```

3. **Code sign (optional):**
   ```bash
   codesign -s "Developer ID Installer: Name" output/*.pkg
   ```

4. **Distribute to users:**
   - Share the DMG file
   - Provide installation instructions
   - Support users with permission setup

## Support

For issues during installation:
1. Check the installation log: `/var/log/phoneunlocker_install.log`
2. Review troubleshooting section above
3. Verify accessibility permissions are granted
4. Ensure macOS 13.0 or later

---

**Last Updated:** 2024
**Version:** 1.0.0
