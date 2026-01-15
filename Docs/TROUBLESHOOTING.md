# Troubleshooting Guide

Solutions for common PhoneUnlocker issues.

## Installation Issues

### Installation Script Fails

**Error: "Xcode Command Line Tools not found"**
```bash
# Install Xcode Command Line Tools
xcode-select --install

# Verify installation
xcode-select -p
# Should output: /Applications/Xcode.app/Contents/Developer
```

**Error: "Permission denied"**
```bash
# Run installer with sudo
sudo bash Installer/install.sh
```

**Error: "Build failed"**
```bash
# Clean and rebuild
cd PhoneUnlocker
xcodebuild clean -scheme PhoneUnlocker
xcodebuild -scheme PhoneUnlocker -configuration Release

# Check for specific errors
xcodebuild -scheme PhoneUnlocker -configuration Release -verbose
```

---

## Launching Issues

### App Won't Launch

**Option 1: Launch from Terminal**
```bash
# Direct launch
/Applications/PhoneUnlocker.app/Contents/MacOS/PhoneUnlocker

# With verbose output
/Applications/PhoneUnlocker.app/Contents/MacOS/PhoneUnlocker --verbose
```

**Option 2: Check System Logs**
```bash
# Real-time log viewing
log stream --predicate 'process == "PhoneUnlocker"' --level debug

# Or check crash logs
log show --predicate 'process == "PhoneUnlocker"' --last 1h
```

**Option 3: Remove and Reinstall**
```bash
# Remove app
rm -rf /Applications/PhoneUnlocker.app

# Reinstall
bash Installer/install.sh
```

**"Cannot open because it is from an unidentified developer"**
```bash
# Remove quarantine attribute
xattr -d com.apple.quarantine /Applications/PhoneUnlocker.app

# Or right-click app in Finder and select "Open"
```

---

## Permissions Issues

### Accessibility Permissions Not Granted

**Symptoms:**
- App launches but can't unlock screensaver
- No response when clicking "Verify with iPhone"

**Solution:**

1. **Check if permission exists:**
   ```bash
   # View current accessibility settings
   sqlite3 ~/Library/Application\ Support/com.apple.sharedfilelist/com.apple.LSSharedFileList.ApplicationRecentDocuments/com.apple.LSSharedFileList.ApplicationRecentDocuments.sfl2 "SELECT * FROM ZSHAREDFILELIST WHERE ZFILENAME LIKE '%PhoneUnlocker%';"
   ```

2. **Grant permission manually:**
   - Open **System Preferences** → **Security & Privacy** → **Accessibility**
   - Click the lock 🔒 and enter your password
   - Click **+** and add `/Applications/PhoneUnlocker.app`
   - Ensure PhoneUnlocker is checked

3. **Restart the app:**
   - Close PhoneUnlocker completely
   - Relaunch from Applications

4. **Reset permissions (advanced):**
   ```bash
   # Remove and re-grant permissions
   # Note: This will reset ALL accessibility permissions
   tccutil reset All com.phoneunlocker.app
   
   # Then manually grant again via System Preferences
   ```

---

## Apple Pay Issues

### "Apple Pay Not Available" Message

**Cause:** Apple Pay not configured on your Mac.

**Solution:**

1. **Check Apple Pay Settings:**
   - System Preferences → Wallet & Apple Pay
   - Ensure you have at least one card added

2. **Add Payment Method:**
   - Click **+ Add Card**
   - Select **Credit or Debit Card**
   - Enter card details
   - Complete verification
   - Wait for card activation (usually instant)

3. **Verify Card is Active:**
   ```bash
   # Check if cards are configured
   defaults read com.apple.Wallet
   ```

4. **Verify on iPhone:**
   - Open **Wallet** app on iPhone
   - Check the same card is present
   - Ensure Face ID is enabled

5. **Restart Mac:**
   - Reboot your Mac
   - Relaunch PhoneUnlocker

---

## Authentication Issues

### Face ID Not Triggering on iPhone

**Symptoms:**
- Click "Verify with iPhone" but no prompt appears
- iPhone doesn't show Face ID screen

**Solution:**

1. **Check Network Connectivity:**
   - Ensure Mac and iPhone are connected (WiFi or Bluetooth)
   - Try switching between WiFi and Bluetooth
   - Restart both devices

2. **Verify iPhone Setup:**
   - Ensure iPhone has Face ID enabled
   - Check Face ID is working (unlock phone with Face ID)
   - Verify Apple Pay is configured on iPhone

3. **Check PassKit:**
   ```bash
   # Verify PassKit framework is available
   ls -la /System/Library/Frameworks/PassKit.framework
   ```

4. **Restart Services:**
   ```bash
   # Restart Bluetooth
   sudo launchctl stop com.apple.bluetoothd
   sleep 2
   sudo launchctl start com.apple.bluetoothd
   ```

---

## Screensaver Issues

### Screensaver Won't Unlock

**Symptoms:**
- Face ID completes but Mac stays locked
- Screensaver remains active after authentication

**Solution:**

1. **Verify Screensaver is Active:**
   ```bash
   # Check screensaver status
   defaults read com.apple.screensaver
   
   # Manually activate screensaver to test
   open -a ScreenSaverEngine
   ```

2. **Check Idle Time Detection:**
   ```bash
   # Check system idle time
   ioreg -l | grep HIDIdleTime
   ```

3. **Grant Input Monitoring Permission:**
   - System Preferences → Security & Privacy → Input Monitoring
   - Add PhoneUnlocker.app if not present

4. **Check IOKit Permissions:**
   ```bash
   # Verify IOKit access is available
   ls -la /dev/null  # Simple system device test
   ```

5. **Restart Screensaver System:**
   ```bash
   # Kill screensaver process
   killall ScreenSaverEngine
   
   # Restart PhoneUnlocker
   killall PhoneUnlocker
   sleep 2
   open -a PhoneUnlocker
   ```

---

## System-Level Issues

### macOS Compatibility Issues

**"This version of macOS is not supported"**
```bash
# Check your macOS version
sw_vers -productVersion

# Should be 13.0 or later
```

**Solution:** Upgrade to macOS 13 (Ventura) or later.

---

### System Integrity Protection (SIP) Issues

**Symptoms:**
- Screensaver won't unlock even after successful Face ID
- IOKit errors in logs

**Solution:**

For advanced users only. SIP might be blocking IOKit access:

1. **Check SIP Status:**
   ```bash
   csrutil status
   # Should show "System Integrity Protection status: enabled."
   ```

2. **Disable SIP (Advanced - use with caution):**
   - Restart in Recovery Mode (⌘R during startup)
   - Open Terminal
   - Run: `csrutil disable`
   - Restart

3. **Re-enable SIP after testing:**
   - Restart in Recovery Mode again
   - Run: `csrutil enable`

---

## Performance Issues

### App Uses Too Much CPU

**Solution:**

1. **Check Activity Monitor:**
   - Open **Activity Monitor**
   - Search for "PhoneUnlocker"
   - Check CPU and Memory usage

2. **Reduce Polling Frequency:**
   Edit [ScreensaverManager.swift](../PhoneUnlocker/PhoneUnlocker/ScreensaverManager.swift):
   ```swift
   timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { [weak self] _ in
       // Increased from 2.0 to 5.0 seconds
       self?.updateScreensaverStatus()
   }
   ```

3. **Rebuild and reinstall:**
   ```bash
   bash Installer/install.sh
   ```

---

## Advanced Debugging

### Enable Debug Logging

```bash
# Export debug environment variable
export PHONE_UNLOCKER_DEBUG=1

# Launch with debug output
/Applications/PhoneUnlocker.app/Contents/MacOS/PhoneUnlocker
```

### Check Log Files

```bash
# System log
log show --predicate 'process == "PhoneUnlocker"' --last 24h

# User logs
~/Library/Logs/PhoneUnlocker/

# Crash reports
~/Library/Logs/DiagnosticMessages/ | grep PhoneUnlocker
```

### Reset Application State

```bash
# Remove all PhoneUnlocker user data
rm -rf ~/Library/Preferences/com.phoneunlocker.*
rm -rf ~/Library/Application\ Support/com.phoneunlocker.*
rm -rf ~/Library/Caches/com.phoneunlocker.*
rm -rf ~/Library/Saved\ Application\ State/com.phoneunlocker.*

# Restart the app
killall PhoneUnlocker
open -a PhoneUnlocker
```

---

## Still Having Issues?

1. **Check existing issues:**
   - Visit [GitHub Issues](https://github.com/maksimvialykh/macOS-phone-unlock/issues)
   - Search for your problem

2. **Create a new issue:**
   - Include:
     - macOS version
     - iPhone model and iOS version
     - Steps to reproduce
     - Error messages (from logs)
     - Output of debug commands

3. **Contact support:**
   - Email: support@phoneunlocker.dev
   - Discord: [Join Community](https://discord.gg/phoneunlocker)

---

## Common Error Messages

| Error | Cause | Solution |
|-------|-------|----------|
| "Apple Pay not available" | No payment method configured | Add card in Wallet & Apple Pay |
| "Accessibility permission required" | PhoneUnlocker not in accessibility list | Add to System Preferences → Accessibility |
| "Failed to unlock screensaver" | Wrong permissions or IOKit issue | Verify all permissions granted |
| "Face ID authentication failed" | No network between Mac and iPhone | Check WiFi/Bluetooth connectivity |
| "Build failed - Pass Kit not found" | PassKit framework missing | Reinstall Xcode |

---

**Last updated:** January 2026
