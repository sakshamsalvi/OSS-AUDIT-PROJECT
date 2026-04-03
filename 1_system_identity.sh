#!/bin/bash

# ==========================================================
# Open Source Software - System Identity Report
# Prepared by: Saksham Salvi
# Registration Number: 24BCE10850
# Topic Chosen: Python
#
# This script collects some basic details about the system
# and also checks whether Python is installed or not.
# ==========================================================

# Personal details
student_name="Saksham Salvi"
registration_no="24BCE10850"
software_name="Python"

# Collecting system details
host_name=$(hostname)
current_user=$(whoami)
kernel_version=$(uname -r)
system_uptime=$(uptime -p)
today_date=$(date "+%A, %d %B %Y")
current_time=$(date "+%I:%M:%S %p %Z")
home_directory="$HOME"

# Finding Linux distribution name
if [ -f /etc/os-release ]; then
    distro_name=$(grep '^PRETTY_NAME=' /etc/os-release | cut -d= -f2 | tr -d '"')
elif [ -f /etc/lsb-release ]; then
    distro_name=$(grep '^DISTRIB_DESCRIPTION=' /etc/lsb-release | cut -d= -f2 | tr -d '"')
elif [ -f /etc/redhat-release ]; then
    distro_name=$(cat /etc/redhat-release)
else
    distro_name="Distribution information not available"
fi

# License note
license_note="Linux is open-source software and is mainly distributed under the GNU General Public License (GPL). The Linux kernel specifically comes under GPL version 2."

clear

echo "=============================================================="
echo "                 OPEN SOURCE SOFTWARE REPORT                  "
echo "=============================================================="
echo ""
echo "Student Name      : $student_name"
echo "Registration No   : $registration_no"
echo "Selected Software : $software_name"
echo ""
echo "--------------------- System Information ---------------------"
echo "Hostname          : $host_name"
echo "Linux Distribution: $distro_name"
echo "Kernel Version    : $kernel_version"
echo "Current User      : $current_user"
echo "Home Directory    : $home_directory"
echo "System Uptime     : $system_uptime"
echo "Current Date      : $today_date"
echo "Current Time      : $current_time"
echo ""
echo "--------------------- License Information --------------------"
echo "$license_note"
echo ""

echo "------------------ Python Installation Check -----------------"

# Checking Python 3
if command -v python3 >/dev/null 2>&1; then
    python3_version=$(python3 --version 2>&1)
    python3_path=$(command -v python3)
    echo "Python 3 is installed."
    echo "Version : $python3_version"
    echo "Path    : $python3_path"
else
    echo "Python 3 is not installed on this system."
fi

echo ""

# Checking Python 2
if command -v python2 >/dev/null 2>&1; then
    python2_version=$(python2 --version 2>&1)
    python2_path=$(command -v python2)
    echo "Python 2 is also installed."
    echo "Version : $python2_version"
    echo "Path    : $python2_path"
else
    echo "Python 2 is not installed (this is normal since it is outdated)."
fi

echo ""
echo "Report generated successfully on $(date '+%d/%m/%Y at %I:%M:%S %p')"

exit 0
