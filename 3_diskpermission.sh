#!/bin/bash

# ==========================================================
# Script: Disk & Permission Auditor
# Name: Saksham Salvi
# Registration No: 24BCE10850
#
# This script checks important system directories,
# looks at permissions, and gives a basic idea of
# disk usage and security.
# ==========================================================

name="Saksham Salvi"
reg_no="24BCE10850"

echo "=============================================================="
echo "              DISK AND PERMISSION AUDIT REPORT                "
echo "=============================================================="
echo "Student: $name"
echo "Registration No: $reg_no"
echo ""

# -------- Important system folders --------
system_dirs=("/etc" "/var/log" "/home" "/usr/bin" "/tmp" "/usr/local" "/opt")

# -------- Function to display directory info --------
show_info() {
    dir=$1

    if [ ! -d "$dir" ]; then
        echo "X $dir not found"
        return
    fi

    permissions=$(ls -ld "$dir" | awk '{print $1}')
    owner=$(ls -ld "$dir" | awk '{print $3}')
    group=$(ls -ld "$dir" | awk '{print $4}')
    size=$(du -sh "$dir" 2>/dev/null | cut -f1)

    [ -z "$size" ] && size="No Access"

    printf "%-15s | %-10s | %-8s | %-8s | %s\n" \
        "$dir" "$size" "$owner" "$group" "$permissions"
}

echo "------------------ System Directory Check -------------------"
echo "Directory       | Size       | Owner    | Group    | Permissions"
echo "--------------------------------------------------------------"

for d in "${system_dirs[@]}"; do
    show_info "$d"
done

# -------- Python related folders --------
echo ""
echo "------------------ Python Directories ------------------------"

python_dirs=(
"/usr/lib/python3"
"/usr/local/lib/python3"
"$HOME/.local/lib/python"
"$HOME/.local/bin"
)

echo "Directory                       | Size       | Owner:Group | Permissions"
echo "--------------------------------------------------------------"

for d in "${python_dirs[@]}"; do
    if [ -d "$d" ]; then
        perm=$(ls -ld "$d" | awk '{print $1}')
        own=$(ls -ld "$d" | awk '{print $3}')
        grp=$(ls -ld "$d" | awk '{print $4}')
        size=$(du -sh "$d" 2>/dev/null | cut -f1)

        printf "✓ %-30s | %-10s | %s:%s | %s\n" "$d" "$size" "$own" "$grp" "$perm"
    else
        printf "✗ %-30s | Not available\n" "$d"
    fi
done

# -------- Python executables --------
echo ""
echo "------------------ Python Commands ---------------------------"

executables=("python" "python3" "pip" "pip3")

echo "Command         | Location                           | Permissions"
echo "--------------------------------------------------------------"

for cmd in "${executables[@]}"; do
    if command -v "$cmd" >/dev/null 2>&1; then
        path=$(which "$cmd")

        if [ -f "$path" ]; then
            perm=$(ls -l "$path" | awk '{print $1}')
            printf "%-15s | %-35s | %s\n" "$cmd" "$path" "$perm"
        else
            printf "%-15s | %-35s | alias/function\n" "$cmd" "$path"
        fi
    else
        printf "%-15s | Not installed\n" "$cmd"
    fi
done

# -------- Disk usage --------
echo ""
echo "------------------ Disk Usage -------------------------------"
df -h

# -------- Basic security check --------
echo ""
echo "------------------ Security Check ---------------------------"

risky=0

for d in "${system_dirs[@]}"; do
    if [ -d "$d" ]; then
        perm=$(ls -ld "$d" | awk '{print $1}')

        # Check if others have write permission
        if [[ "${perm:8:1}" == "w" ]]; then
            echo "Warning: $d might be world-writable ($perm)"
            ((risky++))
        fi
    fi
done

echo ""
echo "Checking /tmp directory:"
ls -ld /tmp

if [ $risky -eq 0 ]; then
    echo "No major permission issues found."
fi

echo ""
echo "Audit finished at $(date '+%I:%M:%S %p on %d/%m/%Y')"
echo "=============================================================="

exit 0
