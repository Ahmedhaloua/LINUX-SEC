#!/usr/bin/env bash
# Grimshield — report generator
# Every module calls log_report() for each check it performs.
# At the end, write_report() dumps everything to a timestamped .txt file.

REPORT_LOG=()

# log_report "Module" "Check description" "applied|skipped|failed" "Detail"
log_report() {
    local module="$1"
    local check="$2"
    local status="$3"
    local detail="$4"
    REPORT_LOG+=("${module}|${check}|${status}|${detail}")
}

write_report() {
    local outfile="grimshield-report-$(date +%Y%m%d-%H%M%S).txt"

    {
        echo "=============================================="
        echo " GRIMSHIELD SECURITY REPORT"
        echo "=============================================="
        echo "Date:        $(date)"
        echo "Host:        $(hostname)"
        echo "Distro:      ${DISTRO_NAME} (${DISTRO_ID})"
        echo "Pkg manager: ${PKG_MANAGER}"
        echo "Init system: ${INIT_SYSTEM}"
        echo "=============================================="
        echo

        local current_module=""
        for entry in "${REPORT_LOG[@]}"; do
            IFS='|' read -r module check status detail <<< "$entry"
            if [ "$module" != "$current_module" ]; then
                echo "--- ${module} ---"
                current_module="$module"
            fi
            printf "  [%s] %s\n" "$status" "$check"
            if [ -n "$detail" ]; then
                printf "        %s\n" "$detail"
            fi
        done

        echo
        echo "=============================================="
        local applied skipped failed
        applied=$(printf '%s\n' "${REPORT_LOG[@]}" | grep -c '|applied|')
        skipped=$(printf '%s\n' "${REPORT_LOG[@]}" | grep -c '|skipped|')
        failed=$(printf '%s\n'  "${REPORT_LOG[@]}" | grep -c '|failed|')
        echo "Summary: ${applied} applied, ${skipped} skipped, ${failed} failed"
        echo "=============================================="
    } > "$outfile"

    echo
    echo -e "\033[1mReport written to: ${outfile}\033[0m"
}
