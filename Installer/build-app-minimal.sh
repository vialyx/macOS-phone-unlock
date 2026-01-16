#!/bin/bash

# PhoneUnlocker Build Without Xcode
# Workaround for systems without full Xcode

set -e

PROJECT_DIR="/Users/maksimvialykh/github/macOS-phone-unlock"
APP_SOURCE="$PROJECT_DIR/PhoneUnlocker/PhoneUnlocker"
APP_BUILD_DIR="/tmp/PhoneUnlocker.app"

echo "➜ Creating minimal app bundle..."

# Create app bundle structure
mkdir -p "$APP_BUILD_DIR/Contents/MacOS"
mkdir -p "$APP_BUILD_DIR/Contents/Resources"

# Create a minimal executable (shell script wrapper)
cat > "$APP_BUILD_DIR/Contents/MacOS/PhoneUnlocker" << 'EXEC'
#!/bin/bash
# PhoneUnlocker - Minimal Launcher
open -a "System Events"
exit 0
EXEC

chmod +x "$APP_BUILD_DIR/Contents/MacOS/PhoneUnlocker"

# Create Info.plist
cat > "$APP_BUILD_DIR/Contents/Info.plist" << 'PLIST'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>CFBundleDevelopmentRegion</key>
	<string>en</string>
	<key>CFBundleExecutable</key>
	<string>PhoneUnlocker</string>
	<key>CFBundleIdentifier</key>
	<string>com.phoneunlocker.app</string>
	<key>CFBundleInfoDictionaryVersion</key>
	<string>6.0</string>
	<key>CFBundleName</key>
	<string>PhoneUnlocker</string>
	<key>CFBundlePackageType</key>
	<string>APPL</string>
	<key>CFBundleShortVersionString</key>
	<string>1.0</string>
	<key>CFBundleVersion</key>
	<string>1</string>
	<key>NSMainStoryboardFile</key>
	<string></string>
	<key>NSPrincipalClass</key>
	<string>NSApplication</string>
</dict>
</plist>
PLIST

echo "✓ App bundle created: $APP_BUILD_DIR"
echo "  Size: $(du -sh $APP_BUILD_DIR | cut -f1)"
