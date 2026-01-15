#!/bin/bash

# PhoneUnlocker Uninstallation Script
# This script will remove the PhoneUnlocker application from your macOS system

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

APP_NAME="PhoneUnlocker.app"
APPS_DIR="/Applications"
APP_PATH="$APPS_DIR/$APP_NAME"

print_header() {
    echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║${NC}    ${RED}PhoneUnlocker Uninstallation${NC}     ${BLUE}║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"
    echo ""
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

main() {
    print_header
    
    if [ ! -d "$APP_PATH" ]; then
        print_error "PhoneUnlocker not found in $APPS_DIR"
        exit 1
    fi
    
    # Confirm uninstallation
    read -p "Remove PhoneUnlocker from $APPS_DIR? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_error "Uninstallation cancelled"
        exit 1
    fi
    
    # Kill any running instances
    killall PhoneUnlocker 2>/dev/null || true
    sleep 1
    
    # Remove the app
    rm -rf "$APP_PATH"
    
    print_success "PhoneUnlocker has been uninstalled"
    echo ""
}

main "$@"
