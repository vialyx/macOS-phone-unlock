#!/usr/bin/env python3
"""
PhoneUnlocker Installer Verification Script
Checks that all installer components are properly set up
"""

import os
import subprocess
from pathlib import Path

class Colors:
    GREEN = '\033[92m'
    RED = '\033[91m'
    YELLOW = '\033[93m'
    BLUE = '\033[94m'
    BOLD = '\033[1m'
    END = '\033[0m'

def check_file(path, description):
    """Check if a file exists"""
    if os.path.isfile(path):
        size = os.path.getsize(path)
        print(f"{Colors.GREEN}✓{Colors.END} {description} ({size:,} bytes)")
        return True
    else:
        print(f"{Colors.RED}✗{Colors.END} {description} - NOT FOUND")
        return False

def check_executable(path, description):
    """Check if a file is executable"""
    if os.path.isfile(path):
        if os.access(path, os.X_OK):
            print(f"{Colors.GREEN}✓{Colors.END} {description} (executable)")
            return True
        else:
            print(f"{Colors.YELLOW}!{Colors.END} {description} (not executable)")
            return False
    else:
        print(f"{Colors.RED}✗{Colors.END} {description} - NOT FOUND")
        return False

def check_directory(path, description):
    """Check if a directory exists"""
    if os.path.isdir(path):
        file_count = len(os.listdir(path))
        print(f"{Colors.GREEN}✓{Colors.END} {description} ({file_count} items)")
        return True
    else:
        print(f"{Colors.RED}✗{Colors.END} {description} - NOT FOUND")
        return False

def check_tool(tool_name):
    """Check if a tool is installed"""
    try:
        subprocess.run(['which', tool_name], capture_output=True, check=True)
        print(f"{Colors.GREEN}✓{Colors.END} {tool_name} installed")
        return True
    except subprocess.CalledProcessError:
        print(f"{Colors.YELLOW}!{Colors.END} {tool_name} not found")
        return False

def main():
    base_dir = "/Users/maksimvialykh/github/macOS-phone-unlock"
    installer_dir = os.path.join(base_dir, "Installer")
    
    print(f"\n{Colors.BOLD}{Colors.BLUE}PhoneUnlocker Installer Verification{Colors.END}\n")
    
    all_ok = True
    
    # Check build scripts
    print(f"{Colors.BOLD}Build Scripts:{Colors.END}")
    all_ok &= check_executable(os.path.join(installer_dir, "build-pkg.sh"), "build-pkg.sh")
    all_ok &= check_executable(os.path.join(installer_dir, "build-dmg.sh"), "build-dmg.sh")
    all_ok &= check_executable(os.path.join(installer_dir, "build-all.sh"), "build-all.sh")
    
    # Check installation scripts
    print(f"\n{Colors.BOLD}Installation Scripts:{Colors.END}")
    all_ok &= check_executable(os.path.join(installer_dir, "scripts/preinstall"), "preinstall script")
    all_ok &= check_executable(os.path.join(installer_dir, "scripts/postinstall"), "postinstall script")
    all_ok &= check_file(os.path.join(installer_dir, "scripts/welcome.txt"), "welcome message")
    all_ok &= check_file(os.path.join(installer_dir, "scripts/postinstall-readme.txt"), "postinstall readme")
    
    # Check distribution files
    print(f"\n{Colors.BOLD}Distribution Configuration:{Colors.END}")
    all_ok &= check_file(os.path.join(installer_dir, "distribution/Distribution.xml"), "Distribution.xml")
    all_ok &= check_file(os.path.join(installer_dir, "distribution/Welcome.html"), "Welcome.html")
    all_ok &= check_file(os.path.join(installer_dir, "distribution/Readme.html"), "Readme.html")
    all_ok &= check_file(os.path.join(installer_dir, "distribution/License.html"), "License.html")
    
    # Check documentation
    print(f"\n{Colors.BOLD}Documentation:{Colors.END}")
    all_ok &= check_file(os.path.join(base_dir, "INSTALLER_QUICKSTART.md"), "INSTALLER_QUICKSTART.md")
    all_ok &= check_file(os.path.join(base_dir, "INSTALLER_GUIDE.md"), "INSTALLER_GUIDE.md")
    all_ok &= check_file(os.path.join(installer_dir, "README.md"), "Installer README.md")
    
    # Check system tools
    print(f"\n{Colors.BOLD}System Tools:{Colors.END}")
    all_ok &= check_tool("xcodebuild")
    all_ok &= check_tool("pkgbuild")
    all_ok &= check_tool("productbuild")
    all_ok &= check_tool("hdiutil")
    
    # Check directories
    print(f"\n{Colors.BOLD}Directories:{Colors.END}")
    check_directory(os.path.join(installer_dir, "scripts"), "scripts/ directory")
    check_directory(os.path.join(installer_dir, "distribution"), "distribution/ directory")
    
    # Summary
    print(f"\n{Colors.BOLD}{Colors.BLUE}Summary:{Colors.END}")
    if all_ok:
        print(f"{Colors.GREEN}✓ All components verified successfully!{Colors.END}")
        print(f"\n{Colors.YELLOW}Next step: Run the build script{Colors.END}")
        print(f"  cd {base_dir}")
        print(f"  ./Installer/build-all.sh")
    else:
        print(f"{Colors.YELLOW}! Some components need attention (see above){Colors.END}")
    
    print()

if __name__ == "__main__":
    main()
