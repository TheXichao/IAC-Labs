#!/usr/bin/env bash
# Sanity-check the IAC toolchain. Usage: ./scripts/check-env.sh
set -uo pipefail
export PATH="/opt/riscv/bin:$PATH"

ok=0
check() {
    if out="$(eval "$2" 2>&1)"; then
        printf '  \033[32m✔\033[0m %-22s %s\n' "$1" "$(head -1 <<<"$out")"
    else
        printf '  \033[31m✘\033[0m %-22s %s\n' "$1" "$(head -1 <<<"$out")"
        ok=1
    fi
}

echo "IAC environment check"
check "verilator"              "verilator --version"
check "riscv64-unknown-elf-gcc" "riscv64-unknown-elf-gcc --version"
check "gtkwave"                "ls -d /Applications/gtkwave.app"
check "surfer"                 "surfer --version"
check "make"                   "make --version"
check "/usr/local/share/verilator" "ls /usr/local/share/verilator/include/verilated.h"
check "VS Code CLI"            "code --version"
exit $ok
