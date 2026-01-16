#!/bin/bash

# PhoneUnlocker PKG Installer Builder
# Creates a professional macOS .pkg installer

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Paths
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_DIR="$SCRIPT_DIR/../PhoneUnlocker"
BUILD_DIR="$SCRIPT_DIR/build"
PKG_DIR="$BUILD_DIR/PhoneUnlocker"
PAYLOAD_DIR="$PKG_DIR/payload"
SCRIPTS_DIR="$PKG_DIR/scripts"
DIST_DIR="$SCRIPT_DIR/distribution"
OUTPUT_DIR="$SCRIPT_DIR/output"

# Application details
APP_NAME="PhoneUnlocker"
BUNDLE_ID="com.phoneunlocker.app"
VERSION="1.0.0"
IDENTIFIER="com.phoneunlocker.app.pkg"

# Print header
print_header() {
    echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║${NC}  ${GREEN}PhoneUnlocker PKG Installer Builder${NC} ${BLUE}║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"
    echo ""
}

print_step() {
    echo -e "${BLUE}➜${NC} $1"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

# Main build process
main() {
    print_header
    
    # Step 1: Check requirements
    print_step "Checking system requirements..."
    
    if ! command -v xcodebuild &> /dev/null; then
        print_error "xcodebuild not found. Full Xcode is required."
        echo ""
        echo "This system has Command Line Tools but needs full Xcode."
        echo ""
        echo "Install Xcode from:"
        echo "  1. App Store: https://apps.apple.com/app/xcode/id497799835"
        echo "  2. Or via: xcode-select --install"
        echo ""
        echo "After installation, run:"
        echo "  sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer"
        echo "  sudo xcodebuild -runFirstLaunch"
        echo ""
        echo "Then try building again:"
        echo "  ./Installer/build-all.sh"
        exit 1
    fi
    print_success "Xcode found"
    
    if ! command -v pkgbuild &> /dev/null; then
        print_error "pkgbuild not found. Please install Xcode Command Line Tools."
        exit 1
    fi
    print_success "pkgbuild found"
    
    if ! command -v productbuild &> /dev/null; then
        print_error "productbuild not found. Please install Xcode Command Line Tools."
        exit 1
    fi
    print_success "productbuild found"
    
    echo ""
    
    # Step 2: Clean previous builds
    print_step "Cleaning previous builds..."
    rm -rf "$BUILD_DIR" "$OUTPUT_DIR"
    mkdir -p "$PAYLOAD_DIR" "$SCRIPTS_DIR" "$OUTPUT_DIR"
    print_success "Build directories prepared"
    
    echo ""
    
    # Step 3: Build the application
    print_step "Building PhoneUnlocker application..."
    
    # Use manual app bundle builder to avoid Xcode project issues
    "$SCRIPT_DIR/build-app-bundle.sh" > /dev/null 2>&1
    
    if [ ! -d "$PAYLOAD_DIR/Applications/PhoneUnlocker.app" ]; then
        print_error "App bundle build failed"
        exit 1
    fi
    print_success "Application bundle created successfully"
    
    echo ""
    
    # Step 4: Copy application to payload
    print_step "Verifying application..."
    
    if [ ! -d "$PAYLOAD_DIR/Applications/PhoneUnlocker.app" ]; then
        print_error "Application not found in payload"
        exit 1
    fi
    
    print_success "Application bundle verified"
    
    echo ""
    
    # Step 5: Prepare installation scripts
    print_step "Preparing installation scripts..."
    
    cp "$SCRIPT_DIR/scripts/preinstall" "$SCRIPTS_DIR/"
    cp "$SCRIPT_DIR/scripts/postinstall" "$SCRIPTS_DIR/"
    
    chmod +x "$SCRIPTS_DIR/preinstall"
    chmod +x "$SCRIPTS_DIR/postinstall"
    
    print_success "Installation scripts prepared"
    
    echo ""
    
    # Step 6: Build component package
    print_step "Building component package..."
    
    pkgbuild \
        --identifier "$IDENTIFIER" \
        --version "$VERSION" \
        --scripts "$SCRIPTS_DIR" \
        --root "$PAYLOAD_DIR" \
        --install-location "/" \
        "$BUILD_DIR/$APP_NAME.pkg"
    
    if [ ! -f "$BUILD_DIR/$APP_NAME.pkg" ]; then
        print_error "Package build failed"
        exit 1
    fi
    print_success "Component package created"
    
    echo ""
    
    # Step 7: Create distribution package
    print_step "Creating distribution package..."
    
    productbuild \
        --distribution "$DIST_DIR/Distribution.xml" \
        --resources "$DIST_DIR" \
        --package-path "$BUILD_DIR" \
        "$OUTPUT_DIR/$APP_NAME-$VERSION.pkg"
    
    if [ ! -f "$OUTPUT_DIR/$APP_NAME-$VERSION.pkg" ]; then
        print_error "Distribution package creation failed"
        exit 1
    fi
    print_success "Distribution package created"
    
    echo ""
    
    # Step 8: Verify the package
    print_step "Verifying package..."
    
    if pkgutil --check-signature "$OUTPUT_DIR/$APP_NAME-$VERSION.pkg" &> /dev/null; then
        print_success "Package verified successfully"
    else
        print_success "Package created (signature optional)"
    fi
    
    echo ""
    
    # Step 9: Display final information
    print_header
    
    PKG_FILE="$OUTPUT_DIR/$APP_NAME-$VERSION.pkg"
    PKG_SIZE=$(du -h "$PKG_FILE" | cut -f1)
    
    echo -e "${GREEN}✓ Installer created successfully!${NC}"
    echo ""
    echo -e "📦 ${BLUE}Package Details:${NC}"
    echo "   Name:    $APP_NAME-$VERSION.pkg"
    echo "   Size:    $PKG_SIZE"
    echo "   Path:    $OUTPUT_DIR/"
    echo "   Bundle:  $IDENTIFIER"
    echo ""
    echo -e "🚀 ${BLUE}To distribute:${NC}"
    echo "   1. Code sign (optional): codesign -s <identity> $PKG_FILE"
    echo "   2. Notarize (optional): xcrun altool --notarize-app -f $PKG_FILE --primary-bundle-id $BUNDLE_ID"
    echo "   3. Share the .pkg file with users"
    echo ""
    echo -e "📖 ${BLUE}For users:${NC}"
    echo "   1. Double-click the .pkg file"
    echo "   2. Follow the installation wizard"
    echo "   3. Grant accessibility permissions"
    echo "   4. Launch PhoneUnlocker from Applications"
    echo ""
    echo -e "${GREEN}✓ Build Complete!${NC}"
    echo ""
}

# Run main function
main "$@"
