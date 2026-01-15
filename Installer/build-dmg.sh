#!/bin/bash

# PhoneUnlocker DMG Creator
# Creates a beautiful disk image for distribution

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_step() {
    echo -e "${BLUE}➜${NC} $1"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

# Paths
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
OUTPUT_DIR="$SCRIPT_DIR/output"
TEMP_DMG_DIR="/tmp/phoneunlocker_dmg"
PKG_FILE="$OUTPUT_DIR/PhoneUnlocker-1.0.0.pkg"

print_step "Creating DMG installer..."

if [ ! -f "$PKG_FILE" ]; then
    print_error "Package file not found: $PKG_FILE"
    print_error "Please run build-pkg.sh first"
    exit 1
fi

# Create temporary directory
rm -rf "$TEMP_DMG_DIR"
mkdir -p "$TEMP_DMG_DIR"

# Copy files
cp "$PKG_FILE" "$TEMP_DMG_DIR/"

# Create link to Applications folder
ln -s /Applications "$TEMP_DMG_DIR/Applications"

# Create DMG
print_step "Building disk image..."
hdiutil create \
    -srcfolder "$TEMP_DMG_DIR" \
    -volname "PhoneUnlocker Installer" \
    -format UDZO \
    -imagekey zlib-level=9 \
    -o "$OUTPUT_DIR/PhoneUnlocker-1.0.0.dmg" \
    2>/dev/null

# Clean up
rm -rf "$TEMP_DMG_DIR"

DMG_FILE="$OUTPUT_DIR/PhoneUnlocker-1.0.0.dmg"
DMG_SIZE=$(du -h "$DMG_FILE" | cut -f1)

print_success "DMG created successfully"
echo ""
echo -e "${GREEN}✓ Complete!${NC}"
echo "   File: PhoneUnlocker-1.0.0.dmg"
echo "   Size: $DMG_SIZE"
echo "   Path: $OUTPUT_DIR/"
echo ""
