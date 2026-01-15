# PhoneUnlocker - Quick Start Guide

Get started with PhoneUnlocker in 5 minutes.

## What is PhoneUnlocker?

PhoneUnlocker is a macOS application that lets you unlock your Mac's screensaver using Face ID on your iPhone. It uses a $0 Apple Pay transaction to trigger the authentication process.

**Benefits:**
- 🔐 Secure Face ID authentication
- 📱 Just pull out your iPhone
- 💨 Instant unlock
- 🎯 No passwords needed

---

## Installation (2 minutes)

### Step 1: Run the Installer
```bash
cd /path/to/macOS-phone-unlock
bash Installer/install.sh
```

### Step 2: Grant Permissions
The installer will prompt you to:
1. Go to **System Preferences → Security & Privacy → Accessibility**
2. Add `PhoneUnlocker.app` to the list
3. Click the lock icon to confirm

That's it! ✓

---

## Setup (3 minutes)

### 1. Ensure Apple Pay is Configured
- **System Preferences → Wallet & Apple Pay**
- Make sure you have a payment card added
- Verify it's enabled on your iPhone too

### 2. Verify Accessibility Permissions
- **System Preferences → Security & Privacy → Accessibility**
- PhoneUnlocker should be in the list and enabled

### 3. Test It Out
1. Launch PhoneUnlocker (or use Spotlight: ⌘Space, type "PhoneUnlocker")
2. Look for the icon in the menu bar (top-right corner)
3. Click it to open the menu

---

## First Time Use

### Unlock Your Screensaver

1. **Screensaver activates** (let your Mac idle, or manually activate)
2. **Click the PhoneUnlocker menu bar icon**
3. **Click "Verify with iPhone"**
4. **Your iPhone shows a Face ID prompt**
5. **Authenticate with Face ID**
6. **Your Mac unlocks instantly** ✓

---

## Common Questions

**Q: Is this secure?**
A: Yes! It uses Apple's PassKit framework and requires Face ID biometric authentication.

**Q: Will I be charged?**
A: No. It uses a $0 transaction—no money is charged.

**Q: Does it work offline?**
A: Mostly. You need WiFi or Bluetooth between your Mac and iPhone for the authentication to work.

**Q: Can anyone use my phone to unlock my Mac?**
A: No. It requires Face ID on your iPhone—only your face works.

**Q: What if I lose my iPhone?**
A: The app simply won't work. You can still unlock with your Mac password as usual.

---

## Troubleshooting

**App won't launch?**
```bash
# Try running from Terminal
/Applications/PhoneUnlocker.app/Contents/MacOS/PhoneUnlocker
```

**"Apple Pay not available" message?**
- Go to System Preferences → Wallet & Apple Pay
- Add a valid payment method
- Restart the app

**Face ID not triggering?**
- Ensure your iPhone is nearby and unlocked
- Check WiFi/Bluetooth is connected
- Verify accessibility permissions are granted

**Screensaver won't unlock?**
- Make sure screensaver is actually active
- Try clicking "Verify with iPhone" again
- Check the "Screensaver Status" in the menu

---

## Next Steps

- 📖 Read the full [README](../Docs/README.md)
- 🛠️ Check [Installation Guide](INSTALLATION.md) for advanced setup
- 🔧 See [Troubleshooting Guide](TROUBLESHOOTING.md) if issues arise

---

## Getting Help

- 🐛 Report bugs: [GitHub Issues](https://github.com/maksimvialykh/macOS-phone-unlock/issues)
- 💬 Ask questions: [GitHub Discussions](https://github.com/maksimvialykh/macOS-phone-unlock/discussions)
- 📧 Email: support@phoneunlocker.dev

---

**Happy unlocking!** 🚀
