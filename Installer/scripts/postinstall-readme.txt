#!/bin/bash

# PhoneUnlocker README Script
# Displayed after successful installation

cat << 'EOF'
╔════════════════════════════════════════════════════════╗
║                                                        ║
║      PhoneUnlocker Installed Successfully! ✓          ║
║                                                        ║
╚════════════════════════════════════════════════════════╝

NEXT STEPS:

1. GRANT ACCESSIBILITY PERMISSIONS (Important!)
   ─────────────────────────────────────────
   • System Preferences → Security & Privacy → Accessibility
   • Click the lock icon and enter your password
   • Click + and add: /Applications/PhoneUnlocker.app
   • Make sure PhoneUnlocker is checked/enabled

2. VERIFY APPLE PAY SETUP
   ──────────────────────
   • System Preferences → Wallet & Apple Pay
   • Ensure you have an active payment card
   • Card must be verified and ready to use

3. LAUNCH THE APPLICATION
   ─────────────────────────
   • Open: Applications → PhoneUnlocker
   • Or press Cmd+Space and search for "PhoneUnlocker"
   • Look for the menu bar icon in the top-right corner

4. TEST IT OUT
   ───────────
   • Activate your screensaver (let Mac idle for 5 min)
   • Click the PhoneUnlocker menu bar icon
   • Click "Verify with iPhone"
   • Complete Face ID on your iPhone
   • Your Mac unlocks instantly!

QUICK TIPS:
• Make sure your iPhone and Mac are connected (WiFi or Bluetooth)
• Face ID works best when your iPhone is nearby
• The app runs continuously in the background
• You can customize idle time in System Preferences

NEED HELP?
─────────
• Documentation: Open Terminal and run:
  open "/Applications/PhoneUnlocker.app/Contents/Resources/Docs"

• Check installation logs:
  log stream --predicate 'process == "PhoneUnlocker"'

• Report issues:
  https://github.com/maksimvialykh/macOS-phone-unlock/issues

ENJOY YOUR NEW SECURITY FEATURE!
─────────────────────────────────

PhoneUnlocker v1.0.0 — Unlock with Face ID 🔓

EOF
