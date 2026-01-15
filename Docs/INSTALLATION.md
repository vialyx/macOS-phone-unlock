# Installation Guide

Complete step-by-step guide to install and configure PhoneUnlocker.

## Prerequisites

Before installing, ensure you have:

- **macOS 13.0 or later** (Ventura or newer)
- **Administrator access** on your Mac
- **Apple Pay** configured with a valid payment method
- **iPhone with Face ID** (iPhone X or newer)
- **WiFi or Bluetooth connectivity** between devices

## Installation Methods

### Method 1: Automatic Installation (Recommended)

The easiest way to install PhoneUnlocker.

#### Step 1: Download
```bash
# If you haven't already, clone the repository
git clone https://github.com/maksimvialykh/macOS-phone-unlock.git
cd macOS-phone-unlock
```

#### Step 2: Run Installer
```bash
bash Installer/install.sh
```

The script will:
- ✅ Check system requirements
- ✅ Build the application
- ✅ Install to /Applications
- ✅ Request permissions
- ✅ Optionally launch the app

#### Step 3: Grant Permissions (automatic prompt)
Follow the on-screen instructions to grant accessibility permissions.

---

### Method 2: Manual Installation

For developers or advanced users.

#### Step 1: Open in Xcode
```bash
open PhoneUnlocker/PhoneUnlocker.xcodeproj
```

#### Step 2: Configure Code Signing
1. Select `PhoneUnlocker` in the project navigator
2. Select the `PhoneUnlocker` target
3. Go to `Signing & Capabilities` tab
4. Ensure "Automatically manage signing" is checked
5. Select your team/account

#### Step 3: Build the App
- Press `⌘B` or select `Product` → `Build`
- The build should complete without errors

#### Step 4: Archive and Export
1. Select `Product` → `Archive`
2. Click `Distribute App`
3. Select `Direct Distribution`
4. Click `Export`
5. Save to `/Applications` folder

#### Step 5: Grant Permissions (see below)

---

### Method 3: Install Pre-built Binary

If a pre-built binary is available:

```bash
# Copy the app to Applications
cp -r PhoneUnlocker.app /Applications/

# Grant execute permissions
chmod -R 755 /Applications/PhoneUnlocker.app

# Grant accessibility permissions (see next section)
```

---

## Granting Permissions

PhoneUnlocker requires accessibility permissions to control the screensaver.

### Step 1: Open System Preferences
1. Click the **Apple menu** (⌘) in the top-left
2. Select **System Preferences** (or **System Settings** on macOS 13+)
3. Click **Security & Privacy** → **Accessibility** (or **Privacy** → **Accessibility** on Ventura+)

### Step 2: Unlock Preferences
1. Click the **lock icon** 🔒 in the bottom-left corner
2. Enter your **Mac password**
3. Click **Unlock**

### Step 3: Add PhoneUnlocker
1. Click the **➕ (Plus)** button
2. Navigate to `/Applications`
3. Select **PhoneUnlocker.app**
4. Click **Open** or **Add**

### Step 4: Verify Permissions
- PhoneUnlocker should now appear in the Accessibility list
- Ensure it's **checked/enabled**
- Click the **lock icon** again to secure preferences

---

## Apple Pay Configuration

PhoneUnlocker uses Apple Pay to trigger authentication. Ensure it's properly configured.

### Step 1: Open Wallet & Apple Pay Settings
1. **System Preferences** → **Wallet & Apple Pay**
2. Or directly: Open **Wallet** app → gear icon ⚙️

### Step 2: Add Payment Method
If you haven't already:
1. Click **➕ Add Card**
2. Select **Credit or Debit Card**
3. Enter card details
4. Complete the verification process
5. Wait for your card to be activated

### Step 3: Set Default Card
1. Ensure at least one card is active
2. You can set a preferred card if you have multiple

### Step 4: Verify on iPhone
1. Open **Wallet** app on your iPhone
2. Verify the same card is synced
3. Ensure Face ID is enabled on your iPhone

---

## Launch and Verify

### First Launch
```bash
# Or simply double-click the app in Finder
open /Applications/PhoneUnlocker.app
```

### Menu Bar Icon
The app runs in the menu bar. You should see the **PhoneUnlocker** icon in the top-right corner:
- 📲 Look for an iPhone icon with a checkmark
- Click to open the menu

### Initial Status Check
1. Click the menu bar icon
2. Check **Screensaver Status**
3. Should show "Inactive" when screensaver is off
4. Should show "Active" when screensaver is active

### Test Authentication
1. Activate your screensaver (or wait for it to activate)
2. Click the menu bar icon
3. Click **"Verify with iPhone"** button
4. Check your iPhone for Face ID prompt
5. Complete Face ID authentication
6. Mac should unlock

---

## Troubleshooting Installation

### "Xcode Command Line Tools not found"
```bash
# Install Xcode Command Line Tools
xcode-select --install

# Then try installer again
bash Installer/install.sh
```

### "Cannot open because it is from an unidentified developer"
```bash
# Remove quarantine attribute
xattr -d com.apple.quarantine /Applications/PhoneUnlocker.app

# Or right-click app and select "Open"
```

### "Permission denied" during installation
```bash
# Run with sudo
sudo bash Installer/install.sh
```

### Build fails with "PhoneUnlocker.app not found"
1. Open Xcode project manually
2. Select `PhoneUnlocker` scheme (top-left dropdown)
3. Select "Any Mac" as the target
4. Press `⌘B` to build
5. Check for error messages

### Accessibility permissions not working
1. Restart the Mac (sometimes necessary)
2. Remove and re-add PhoneUnlocker from Accessibility
3. Log out and back in
4. Try granting permissions to all apps: 
   - Hold ⌘ while restarting
   - Disable System Integrity Protection (advanced users only)

---

## Uninstallation

### Using the uninstall script:
```bash
bash Installer/uninstall.sh
```

### Manual removal:
```bash
# Remove the application
rm -rf /Applications/PhoneUnlocker.app

# Remove from Accessibility (System Preferences → Security & Privacy → Accessibility)
# (Manual step)
```

---

## Post-Installation

### Create Alias (Optional)
For quick access from Terminal:
```bash
alias phoneunlocker='open -a PhoneUnlocker'
```

### Add to Login Items (Optional)
To auto-launch on startup:
1. **System Preferences** → **General** → **Login Items**
2. Click **➕** and add PhoneUnlocker.app
3. Or check "Open at login" in app preferences

### Launch at Startup (Advanced)
```bash
# Create LaunchAgent
mkdir -p ~/Library/LaunchAgents
cat > ~/Library/LaunchAgents/com.phoneunlocker.app.plist << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.phoneunlocker.app</string>
    <key>ProgramArguments</key>
    <array>
        <string>/Applications/PhoneUnlocker.app/Contents/MacOS/PhoneUnlocker</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
</dict>
</plist>
EOF

# Load it
launchctl load ~/Library/LaunchAgents/com.phoneunlocker.app.plist
```

---

## Getting Help

If you encounter issues:

1. **Check logs:**
   ```bash
   log stream --predicate 'process == "PhoneUnlocker"' --level debug
   ```

2. **Visit:** [GitHub Issues](https://github.com/maksimvialykh/macOS-phone-unlock/issues)

3. **Email:** support@phoneunlocker.dev

---

**Installation complete!** 🎉 You can now use PhoneUnlocker to unlock your Mac with Face ID.
