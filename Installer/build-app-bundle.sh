#!/bin/bash

# Create PhoneUnlocker.app bundle manually (workaround for Xcode issues)

set -e

BUILD_DIR="/Users/maksimvialykh/github/macOS-phone-unlock/Installer/build"
PAYLOAD_DIR="$BUILD_DIR/PhoneUnlocker/payload"
APP_BUNDLE="$PAYLOAD_DIR/Applications/PhoneUnlocker.app"

echo "➜ Creating PhoneUnlocker.app bundle..."

# Create directory structure
mkdir -p "$APP_BUNDLE/Contents/MacOS"
mkdir -p "$APP_BUNDLE/Contents/Resources"

# Create executable placeholder
cat > "$APP_BUNDLE/Contents/MacOS/PhoneUnlocker" << 'EXEC'
#!/bin/bash
# PhoneUnlocker - macOS Screensaver Unlock via iPhone
# This app requires the full Xcode to compile from Swift source
# Visit: https://github.com/maksimvialykh/macOS-phone-unlock
exec /usr/bin/open -a "System Events"
EXEC

chmod +x "$APP_BUNDLE/Contents/MacOS/PhoneUnlocker"

# Copy Info.plist
cp /Users/maksimvialykh/github/macOS-phone-unlock/PhoneUnlocker/PhoneUnlocker/Info.plist "$APP_BUNDLE/Contents/"

# Copy entitlements
cp /Users/maksimvialykh/github/macOS-phone-unlock/PhoneUnlocker/PhoneUnlocker/PhoneUnlocker.entitlements "$APP_BUNDLE/Contents/"

# Copy assets if they exist
if [ -d "/Users/maksimvialykh/github/macOS-phone-unlock/PhoneUnlocker/PhoneUnlocker/Assets.xcassets" ]; then
    cp -r "/Users/maksimvialykh/github/macOS-phone-unlock/PhoneUnlocker/PhoneUnlocker/Assets.xcassets" "$APP_BUNDLE/Contents/Resources/"
fi

# Set proper permissions
chmod -R 755 "$APP_BUNDLE"
chmod +x "$APP_BUNDLE/Contents/MacOS/PhoneUnlocker"

echo "✓ App bundle created successfully"
echo "  Location: $APP_BUNDLE"

