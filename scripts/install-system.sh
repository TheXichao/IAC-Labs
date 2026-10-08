#!/usr/bin/env bash
# One-off steps from Lab0's tools/darwin.sh that need sudo.
# Safe to re-run. Usage: ./scripts/install-system.sh
set -euo pipefail

TOOLCHAIN_URL="https://github.com/EIE2-IAC-Labs/Lab0-devtools/releases/download/v1.0.0/riscv-gnu-toolchain-2022-09-21-Darwin-arm64.tar.gz"
TOOLCHAIN_SHA256="41aa2d8c28cfa4e9e7ade2c735765bb0d8467cfeb179fc932d74ee2c1726463c"

log() { printf '\n[iac] %s\n' "$1"; }

# 1. Stable Verilator include path used by the lab .vscode configs.
#    Points at Homebrew's version-independent "opt" link, so it survives `brew upgrade`.
log "Linking /usr/local/share/verilator -> Homebrew Verilator"
sudo mkdir -p /usr/local/share
sudo ln -sfn "$(brew --prefix verilator)/share/verilator" /usr/local/share/verilator

# 2. RISC-V GNU toolchain (course prebuilt, GCC 12.2) into /opt/riscv,
#    the path the lab Makefiles hard-code.
if [[ -x /opt/riscv/bin/riscv64-unknown-elf-gcc ]]; then
    log "RISC-V toolchain already in /opt/riscv, skipping"
else
    tmp="$(mktemp -d)"
    trap 'rm -rf "$tmp"' EXIT
    log "Downloading RISC-V toolchain"
    curl -fL --progress-bar -o "$tmp/riscv.tar.gz" "$TOOLCHAIN_URL"
    echo "$TOOLCHAIN_SHA256  $tmp/riscv.tar.gz" | shasum -a 256 -c -
    sudo tar -xzf "$tmp/riscv.tar.gz" -C /opt
fi

# 3. PATH (idempotent).
line='export PATH="/opt/riscv/bin:$PATH"  # IAC RISC-V toolchain'
if ! grep -qF '/opt/riscv/bin' ~/.zshrc; then
    log "Adding /opt/riscv/bin to PATH in ~/.zshrc"
    printf '\n%s\n' "$line" >> ~/.zshrc
fi

log "Done. Open a new terminal, then run: ./scripts/check-env.sh"
