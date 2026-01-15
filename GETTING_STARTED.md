# 🚀 Getting Started with PhoneUnlocker

Welcome! This guide will help you get PhoneUnlocker up and running in minutes.

## ⚡ 30-Second Summary

PhoneUnlocker lets you unlock your Mac's screensaver using Face ID on your iPhone.

**What you need:**
- macOS 13+ (Ventura or newer)
- Apple Pay configured
- iPhone with Face ID

**Installation:**
```bash
bash Installer/install.sh
```

That's it! 🎉

---

## 📖 Choose Your Path

### 🏃 Fastest Path (5 minutes)
If you just want to get it working:

1. **[Install](Docs/QUICKSTART.md)** - Follow the 5-minute guide
2. **[Use](#how-to-use)** - Start unlocking immediately
3. **[Troubleshoot](Docs/TROUBLESHOOTING.md)** - If something breaks

### 📚 Learning Path (20 minutes)
If you want to understand how it works:

1. **[Read This](#how-it-works)** - Understand the concept
2. **[Install](Docs/INSTALLATION.md)** - Detailed setup guide
3. **[Setup Security](#security-setup)** - Configure properly
4. **[Use Effectively](#pro-tips)** - Best practices

### 🛠️ Developer Path (1 hour)
If you want to modify or contribute:

1. **[Development Setup](Docs/DEVELOPMENT.md)** - Set up environment
2. **[Explore Code](#project-structure)** - Understand architecture
3. **[Contribute](CONTRIBUTING.md)** - Help improve the project

---

## ⚙️ Prerequisites Check

Before installing, verify you have everything:

### macOS Requirements
```bash
# Check your macOS version
sw_vers -productVersion
# Should be 13.0 or higher (Ventura+)
```

### Apple Pay Configuration
1. Open **System Preferences** → **Wallet & Apple Pay**
2. Add a payment card if you haven't already
3. Ensure a card is marked as "Default"

### iPhone Setup
1. Check your iPhone has Face ID (not Touch ID)
2. Ensure Face ID is working (unlock your phone with face)
3. Ensure Wallet app is installed
4. Ensure Apple Pay is configured on iPhone

### Administrator Access
- PhoneUnlocker requires admin access to install
- You'll be prompted for your password during setup

---

## 🚀 Installation Methods

### Method 1: Automated (Recommended) ⭐

The easiest way - script handles everything.

```bash
# Navigate to project directory
cd /path/to/macOS-phone-unlock

# Run the installer
bash Installer/install.sh
```

The script will:
- ✅ Check your system
- ✅ Build the app
- ✅ Install to /Applications
- ✅ Request permissions
- ✅ Launch the app

**Time: 2-5 minutes**

### Method 2: Manual Installation

If you prefer to do it step-by-step:

1. **Open in Xcode**
   ```bash
   open PhoneUnlocker/PhoneUnlocker.xcodeproj
   ```

2. **Build the app**
   - Press `⌘B` or go to Product → Build

3. **Archive**
   - Select Product → Archive
   - Click Distribute App → Direct Distribution

4. **Export to Applications**
   - Save the app to `/Applications`

5. **Grant permissions** (see below)

**Time: 5-10 minutes**

### Method 3: Pre-built Binary

If a binary is available:

```bash
cp -r PhoneUnlocker.app /Applications/
chmod -R 755 /Applications/PhoneUnlocker.app
```

---

## 🔐 Security Setup

After installation, grant necessary permissions:

### Step 1: Accessibility Permissions (Required)

1. Open **System Preferences**
2. Go to **Security & Privacy** → **Accessibility**
3. Click the lock 🔒 and enter your password
4. Click **+** button
5. Navigate to `/Applications`
6. Select `PhoneUnlocker.app`
7. Click **Open**

PhoneUnlocker should now appear in the list and be checked.

### Step 2: Apple Pay Verification

1. **System Preferences** → **Wallet & Apple Pay**
2. Verify you have an active payment card
3. Check "Allow payments on locked Mac" if available

### Step 3: iPhone Sync

1. Open **Wallet** app on your iPhone
2. Verify the payment card is present
3. Ensure Apple Pay works on your iPhone

---

## ✅ Verify Installation

### Check App is Installed
```bash
ls -la /Applications/PhoneUnlocker.app
```

You should see the app directory.

### Launch from Spotlight
1. Press `⌘ Space`
2. Type "PhoneUnlocker"
3. Press Enter

You should see the menu bar icon appear in the top-right corner.

### Check Menu Bar
Look for the PhoneUnlocker icon in the top-right corner of your screen.

---

## 🎯 How to Use

### Unlock Your Screensaver

**Step 1: Activate Screensaver**
- Wait for your Mac to idle (default: 5 minutes)
- Or manually activate: `open -a ScreenSaverEngine`

**Step 2: Click Menu Bar Icon**
- Look for the PhoneUnlocker icon (top-right corner)
- Click it to open the menu

**Step 3: Click Unlock Button**
- Click "Verify with iPhone" button
- You should see a status: "Screensaver Active"

**Step 4: Face ID on iPhone**
- Look at your iPhone
- A payment sheet appears automatically
- Complete Face ID authentication

**Step 5: Mac Unlocks** ✓
- After Face ID succeeds
- Mac screensaver unlocks automatically
- You can continue working

### Keyboard Shortcut (Future)
*Coming in v1.1.0*

---

## 🔧 Configuration

### Change Idle Timeout

To change when screensaver activates:

1. **System Preferences** → **Lock Screen**
2. Adjust "Turn display off after:" setting
3. Also adjust "Require password after sleep"

### Disable for Now

If you need to disable PhoneUnlocker temporarily:

```bash
# Quit the app
killall PhoneUnlocker

# Relaunch when needed
open -a PhoneUnlocker
```

### Auto-Launch on Startup

To run PhoneUnlocker automatically when you log in:

**Option 1: System Preferences**
1. **System Preferences** → **General** → **Login Items**
2. Click **+** and add PhoneUnlocker.app

**Option 2: Using defaults**
```bash
# Add to login items
osascript -e 'tell application "System Events" to make login item at end with properties {path:"/Applications/PhoneUnlocker.app", hidden:false}'
```

---

## 🆘 Quick Troubleshooting

### "Apple Pay not available"
- **Solution:** Add a payment card in Wallet & Apple Pay settings
- See [TROUBLESHOOTING.md](Docs/TROUBLESHOOTING.md) for details

### "App won't launch"
- **Solution:** Check accessibility permissions are granted
- See [TROUBLESHOOTING.md](Docs/TROUBLESHOOTING.md) for details

### "Face ID not working"
- **Solution:** Ensure iPhone and Mac are on same WiFi
- Check Face ID works on iPhone
- See [TROUBLESHOOTING.md](Docs/TROUBLESHOOTING.md) for details

### "Screensaver won't unlock"
- **Solution:** Verify accessibility permissions
- Ensure screensaver is actually active
- See [TROUBLESHOOTING.md](Docs/TROUBLESHOOTING.md) for details

**Need more help?** Read the full [Troubleshooting Guide](Docs/TROUBLESHOOTING.md)

---

## 📚 Read More

### For Regular Users
- **[Quick Start](Docs/QUICKSTART.md)** - 5-minute overview
- **[Installation](Docs/INSTALLATION.md)** - Detailed setup
- **[Troubleshooting](Docs/TROUBLESHOOTING.md)** - Problem solving
- **[Full README](Docs/README.md)** - Complete documentation

### For Developers
- **[Development Guide](Docs/DEVELOPMENT.md)** - Build & contribute
- **[Project Overview](PROJECT_OVERVIEW.md)** - Technical details
- **[Changelog](CHANGELOG.md)** - Version history

---

## 🎯 Common Questions

**Q: Is this secure?**
A: Yes! Uses Face ID biometric authentication via Apple's PassKit framework.

**Q: Will I be charged money?**
A: No. Uses a $0 transaction—no charges appear on your card.

**Q: What if I lose my iPhone?**
A: The app simply won't work. You can still unlock with your Mac password.

**Q: Does it work offline?**
A: Mostly. You need WiFi or Bluetooth between your Mac and iPhone.

**Q: Can someone else unlock my Mac?**
A: No. It requires YOUR Face ID—biometric authentication.

**Q: What macOS versions are supported?**
A: macOS 13+ (Ventura, Sonoma, Sequoia)

**Q: What iPhones are supported?**
A: Any iPhone with Face ID (iPhone X and newer)

---

## 💡 Pro Tips

### Tip 1: Keep iPhone Nearby
For best experience, keep your iPhone on the same WiFi network or close by with Bluetooth.

### Tip 2: Face ID Setup
Ensure Face ID works perfectly on your iPhone:
- Go to Settings → Face ID & Passcode
- Run "Attention Aware Features" setup
- Test Face ID unlocking your phone

### Tip 3: Accessibility Permissions
If unlock doesn't work:
- Recheck accessibility permissions
- Sometimes a reboot is needed
- Log out and back in if issues persist

### Tip 4: Apple Pay Setup
Ensure Apple Pay is ready:
- Add a valid payment card
- Mark one as "Default"
- Test Apple Pay on iPhone

### Tip 5: Create Alias (Terminal)
For quick access:
```bash
echo "alias phoneunlocker='open -a PhoneUnlocker'" >> ~/.zshrc
source ~/.zshrc

# Now just type: phoneunlocker
```

---

## 🚀 Next Steps

### Immediate Next Steps
1. ✅ Verify system meets requirements
2. ✅ Install using automated script
3. ✅ Grant accessibility permissions
4. ✅ Test with your iPhone

### Then Explore
1. 📖 Read full documentation
2. 🔧 Configure for your preferences
3. 💡 Learn pro tips
4. 🐛 Report issues if found

### If You Want to Contribute
1. 📚 Read [Development Guide](Docs/DEVELOPMENT.md)
2. 🍴 Fork on GitHub
3. 🔧 Make improvements
4. 📤 Submit pull request

---

## 📞 Get Help

### Documentation First
1. Check [FAQ](#common-questions) above
2. Read [Troubleshooting](Docs/TROUBLESHOOTING.md)
3. Check [Full README](Docs/README.md)

### Community
- 💬 **Discussions:** [GitHub Discussions](https://github.com/maksimvialykh/macOS-phone-unlock/discussions)
- 🐛 **Issues:** [GitHub Issues](https://github.com/maksimvialykh/macOS-phone-unlock/issues)
- 📧 **Email:** support@phoneunlocker.dev

---

## 🎉 You're Ready!

You should now have PhoneUnlocker installed and ready to use.

**Quick recap:**
- ✅ App installed to `/Applications`
- ✅ Accessibility permissions granted
- ✅ Apple Pay configured
- ✅ Menu bar icon visible
- ✅ Ready to unlock!

**To use:**
1. Let screensaver activate
2. Click menu bar icon
3. Click "Verify with iPhone"
4. Complete Face ID
5. Mac unlocks instantly ✓

**Questions?** Check [Troubleshooting](Docs/TROUBLESHOOTING.md) or contact support.

**Want to contribute?** See [Development Guide](Docs/DEVELOPMENT.md).

---

## 📜 Important Notes

- **No Data Collection** - PhoneUnlocker doesn't collect any data
- **Privacy First** - All processing happens locally on your Mac
- **Open Source** - Code is available for inspection
- **Free to Use** - MIT License, free for personal and commercial use

---

**Happy unlocking!** 🔓

For detailed information, visit our documentation:
- Quick Start: [5 minutes](Docs/QUICKSTART.md)
- Installation: [Step by step](Docs/INSTALLATION.md)
- Troubleshooting: [Problem solving](Docs/TROUBLESHOOTING.md)
- Full Docs: [Complete guide](Docs/README.md)
