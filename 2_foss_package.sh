#!/bin/bash

# ==========================================================
# Script: FOSS Package Inspector
# Name: Saksham Salvi
# Registration No: 24BCE10850
#
# This script checks whether a given package (default: python3)
# is installed on the system and shows some basic details.
# ==========================================================

# -------- Basic Details --------
package_name="python3"
student_name="Saksham Salvi"
reg_no="24BCE10850"

echo "=============================================================="
echo "                 FOSS PACKAGE INSPECTOR                       "
echo "=============================================================="
echo "Student: $student_name"
echo "Registration No: $reg_no"
echo ""

# -------- Function to check using dpkg --------
check_with_dpkg() {
    dpkg -l | grep -q "^[[:space:]]*ii[[:space:]]*$1"
}

# -------- Function to check using rpm --------
check_with_rpm() {
    rpm -q "$1" >/dev/null 2>&1
}

# -------- Function to show dpkg details --------
show_dpkg_details() {
    echo "Package details (Debian-based system):"
    dpkg -l "$1" 2>/dev/null | tail -1 | awk '{print "Name: " $2 "\nVersion: " $3}'
    apt-cache show "$1" 2>/dev/null | grep "^Description:" | head -1
}

# -------- Function to show rpm details --------
show_rpm_details() {
    echo "Package details (RPM-based system):"
    rpm -qi "$1" 2>/dev/null | grep -E "Name|Version|License|Summary"
}

echo "--------------------------------------------------------------"
echo "Checking if '$package_name' is installed..."
echo "--------------------------------------------------------------"

# -------- Detect system type and check --------
installed=false

if command -v dpkg >/dev/null 2>&1; then
    package_manager="dpkg"
    if check_with_dpkg "$package_name"; then
        installed=true
    fi

elif command -v rpm >/dev/null 2>&1; then
    package_manager="rpm"
    if check_with_rpm "$package_name"; then
        installed=true
    fi

else
    package_manager="command"
    if command -v "$package_name" >/dev/null 2>&1; then
        installed=true
    fi
fi

# -------- Output Result --------
if [ "$installed" = true ]; then
    echo "✔ $package_name is installed."
    echo ""

    if [ "$package_manager" = "dpkg" ]; then
        show_dpkg_details "$package_name"

    elif [ "$package_manager" = "rpm" ]; then
        show_rpm_details "$package_name"

    else
        echo "Basic information:"
        echo "Location: $(which $package_name)"
        $package_name --version 2>&1 | head -3
    fi

else
    echo "✖ $package_name is not installed on this system."
fi

# -------- Small FOSS Note Section --------
echo ""
echo "------------------ FOSS Thought ------------------"

case "$package_name" in
    python|python3)
        echo "Python follows the idea: 'Simple is better than complex.'"
        ;;
    git)
        echo "Git was created by Linus Torvalds to support open collaboration."
        ;;
    firefox)
        echo "Firefox focuses on privacy and open web standards."
        ;;
    *)
        echo "Every open-source tool has its own unique story."
        ;;
esac

# -------- Extra Notes using loop --------
echo ""
echo "Some popular open-source tools:"
for tool in git firefox vlc; do
    case $tool in
        git) echo "- Git: Version control system" ;;
        firefox) echo "- Firefox: Open-source browser" ;;
        vlc) echo "- VLC: Free media player" ;;
    esac
done

echo ""
echo "Report completed at $(date '+%I:%M:%S %p')"
echo "=============================================================="

exit 0
