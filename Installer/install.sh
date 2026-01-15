#!/bin/bash

# PhoneUnlocker Installation Script
# This script will install the PhoneUnlocker application on your macOS system

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Paths
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_DIR="$SCRIPT_DIR/../PhoneUnlocker"
BUILD_DIR="$PROJECT_DIR/build"
APP_NAME="PhoneUnlocker.app"
APPS_DIR="/Applications"

# Functions
print_header() {
    echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║${NC}    ${GREEN}PhoneUnlocker Installation${NC}       ${BLUE}║${NC}"
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

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

check_requirements() {
    print_step "Checking system requirements..."
    
    # Check macOS version
    OS_VERSION=$(sw_vers -productVersion)
    MAJOR=$(echo "$OS_VERSION" | cut -d. -f1)
    
    if [ "$MAJOR" -lt 13 ]; then
        print_error "macOS 13.0 or later required (current: $OS_VERSION)"
        exit 1
    fi
    print_success "macOS version compatible ($OS_VERSION)"
    
    # Check Xcode Command Line Tools
    if ! xcode-select -p &> /dev/null; then
        print_error "Xcode Command Line Tools not found"
        echo "Please install them with: xcode-select --install"
        exit 1
    fi
    print_success "Xcode Command Line Tools found"
    
    # Check if Xcode is available
    if ! command -v xcodebuild &> /dev/null; then
        print_error "Xcode not found"
        echo "Please install Xcode from the App Store"
        exit 1
    fi
    print_success "Xcode is available"
}

build_app() {
    print_step "Building PhoneUnlocker application..."
    
    if [ ! -d "$PROJECT_DIR" ]; then
        print_error "Project directory not found: $PROJECT_DIR"
        exit 1
    fi
    
    cd "$PROJECT_DIR"
    
    # Clean previous builds
    print_step "Cleaning previous builds..."
    rm -rf "$BUILD_DIR" 2>/dev/null || true
    
    # Build the app
    print_step "Compiling source code (this may take a few minutes)..."
    xcodebuild -scheme PhoneUnlocker -configuration Release -derivedDataPath "$BUILD_DIR" \
        BUILD_DIR="$BUILD_DIR" -quiet
    
    if [ ! -d "$BUILD_DIR/Release/$APP_NAME" ]; then
        print_error "Build failed"
        exit 1
    fi
    print_success "Application built successfully"
}

install_app() {
    print_step "Installing application..."
    
    # Check if app already exists
    if [ -d "$APPS_DIR/$APP_NAME" ]; then
        print_warning "$APP_NAME already exists in $APPS_DIR"
        read -p "Replace existing installation? (y/n) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            print_step "Removing existing installation..."
            rm -rf "$APPS_DIR/$APP_NAME"
        else
            print_error "Installation cancelled"
            exit 1
        fi
    fi
    
    # Copy app to Applications
    print_step "Copying application to $APPS_DIR..."
    cp -r "$BUILD_DIR/Release/$APP_NAME" "$APPS_DIR/$APP_NAME"
    
    # Fix permissions
    chmod -R 755 "$APPS_DIR/$APP_NAME"
    
    print_success "Application installed to $APPS_DIR/$APP_NAME"
}

grant_permissions() {
    print_step "Setting up permissions..."
    
    # Grant accessibility permissions
    print_step "Granting accessibility permissions..."
    
    # Add the app to accessibility permissions
    sqlite3 ~/Library/Application\ Support/com.apple.sharedfilelist/com.apple.LSSharedFileList.ApplicationRecentDocuments/com.apple.LSSharedFileList.ApplicationRecentDocuments.sfl2 "INSERT OR REPLACE INTO ZSHAREDFILELIST VALUES (NULL, '$APPS_DIR/$APP_NAME', 0, NULL, 0)" 2>/dev/null || true
    
    print_warning "Please grant accessibility permissions:"
    echo "  1. Open System Preferences → Security & Privacy → Accessibility"
    echo "  2. Click the lock to make changes"
    echo "  3. Add 'PhoneUnlocker' to the list of apps"
    echo ""
}

launch_app() {
    read -p "Launch PhoneUnlocker now? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        print_step "Launching PhoneUnlocker..."
        open "$APPS_DIR/$APP_NAME"
        sleep 2
        print_success "PhoneUnlocker is now running"
    fi
}

main() {
    print_header
    
    check_requirements
    echo ""
    
    build_app
    echo ""
    
    install_app
    echo ""
    
    grant_permissions
    echo ""
    
    echo -e "${GREEN}╔════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║${NC}    Installation Complete!               ${GREEN}║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════╝${NC}"
    echo ""
    
    launch_app
}

# Run main function
main "$@"
