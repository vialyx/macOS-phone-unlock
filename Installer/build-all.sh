#!/bin/bash

# PhoneUnlocker Complete Build Script
# Builds the application and creates both PKG and DMG installers

set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Colors
BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}════════════════════════════════════════${NC}"
echo -e "${GREEN}PhoneUnlocker Complete Build${NC}"
echo -e "${BLUE}════════════════════════════════════════${NC}"
echo ""

# Build PKG
echo -e "${YELLOW}Step 1/2: Creating PKG installer...${NC}"
echo ""
"$SCRIPT_DIR/build-pkg.sh"

echo ""
echo -e "${YELLOW}Step 2/2: Creating DMG distribution...${NC}"
echo ""
"$SCRIPT_DIR/build-dmg.sh"

echo ""
echo -e "${GREEN}✓ All builds complete!${NC}"
echo -e "  📦 Output directory: $SCRIPT_DIR/output/"
echo ""
echo -e "${BLUE}Ready to distribute:${NC}"
echo "  • PhoneUnlocker-1.0.0.pkg (direct installer)"
echo "  • PhoneUnlocker-1.0.0.dmg (disk image for sharing)"
echo ""
