#!/bin/bash

# ==========================================================
# Script: Run All OSS Project Scripts
# Author: Saksham Salvi
# Registration No: 24BCE10850
# ==========================================================

set -euo pipefail

# -------- Colors --------
green="\033[1;32m"
red="\033[1;31m"
yellow="\033[1;33m"
cyan="\033[1;36m"
bold="\033[1m"
reset="\033[0m"

# -------- Setup --------
base_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
report_dir="$base_dir/reports"
log_file="$report_dir/run_$(date '+%Y-%m-%d_%H-%M-%S').log"

mkdir -p "$report_dir"

start_time=$(date +%s)
failed=()

# -------- Logging --------
log() {
    echo -e "$@" | tee -a "$log_file"
}

# -------- Script Runner --------
run_script() {
    local name="$1"
    local file="$2"
    local start end duration

    log ""
    log "${cyan}${bold}Running: $name${reset}"

    if [ ! -f "$file" ]; then
        log "${red}File not found: $file${reset}"
        failed+=("$name")
        return
    fi

    start=$(date +%s)

    # Special handling for Script 4
    if [[ "$file" == *"4_logfileanalyzer.sh" ]]; then
        log "${yellow}Creating sample log file...${reset}"

        cat > "$base_dir/sample.log" <<EOF
INFO: system started
ERROR: something failed
WARNING: memory low
ERROR: retry failed
INFO: process completed
EOF

        if bash "$file" "$base_dir/sample.log" "error" | tee -a "$log_file"; then
            :
        else
            failed+=("$name")
        fi

    # Special handling for Script 5 (auto input)
    elif [[ "$file" == *"5_opensourcemanifesto.sh" ]]; then
        if bash "$file" <<EOF | tee -a "$log_file"
Linux
Freedom
Open source project
EOF
        then
            :
        else
            failed+=("$name")
        fi

    else
        if bash "$file" | tee -a "$log_file"; then
            :
        else
            failed+=("$name")
        fi
    fi

    end=$(date +%s)
    duration=$((end - start))

    if [[ ! " ${failed[*]} " =~ " $name " ]]; then
        log "${green}$name completed in ${duration}s${reset}"
    else
        log "${red}$name failed in ${duration}s${reset}"
    fi
}

# -------- Header --------
log "${cyan}${bold}"
log "=============================================================="
log "           OPEN SOURCE SOFTWARE PROJECT RUNNER                "
log "=============================================================="
log "${reset}"

log "Started at: $(date '+%A, %d %B %Y - %H:%M:%S')"
log "Log file : $log_file"

# -------- Run All Scripts --------
run_script "Script 1 - System Identity" "$base_dir/1_system_identity.sh"
run_script "Script 2 - Package Inspector" "$base_dir/2_foss_package.sh"
run_script "Script 3 - Disk & Permission Auditor" "$base_dir/3_diskpermission.sh"
run_script "Script 4 - Log File Analyzer" "$base_dir/4_logfileanalyzer.sh"
run_script "Script 5 - Open Source Manifesto" "$base_dir/5_opensourcemanifesto.sh"

# -------- Summary --------
end_time=$(date +%s)
total_time=$((end_time - start_time))

log ""
log "${cyan}${bold}==============================================================${reset}"
log "${bold}Execution Summary${reset}"
log "Total time: ${total_time}s"

if [ ${#failed[@]} -eq 0 ]; then
    log "${green}All scripts executed successfully!${reset}"
else
    log "${red}Some scripts failed:${reset}"
    for f in "${failed[@]}"; do
        log " - $f"
    done
fi

log "${cyan}${bold}==============================================================${reset}"
