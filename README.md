# ELEC50010 – Instruction Architectures & Compilers

Course site: <https://elec50010-iac.github.io/course-website/>

## Layout

```
IAC/
├── iac.code-workspace   # open this in VS Code
├── lab0-devtools/       # upstream Lab0 clone (read-only: keep it pristine so `git pull` works)
├── labs/                # one folder per lab, tracked in this repo via git subtree
├── cpu/                 # team coursework repo (separate, gitignored here)
├── notes/               # lecture/lab notes (Markdown / Obsidian vault)
└── scripts/
    ├── install-system.sh  # sudo steps: /opt/riscv toolchain + Verilator include link
    └── check-env.sh       # verify every tool is on PATH
```

## Tools

| Tool | Source | Location |
|---|---|---|
| Verilator 5.x | `brew install verilator` | `/opt/homebrew/bin`, includes linked at `/usr/local/share/verilator` |
| RISC-V GCC 12.2 (`riscv64-unknown-elf-*`) | course prebuilt tarball | `/opt/riscv/bin` |
| GTKWave 3.3.107 | `brew install --cask gtkwave` (x86, runs via Rosetta) | `/Applications/gtkwave.app` |
| Surfer | `brew install surfer` (native arm64; also a VS Code extension) | `/opt/homebrew/bin/surfer` |

## Workflow

1. Add each new lab as a subtree (keeps the files in this repo, but you can still pull
   staff fixes later):
   ```bash
   git subtree add  --prefix=labs/lab1 https://github.com/ELEC50010-IAC/<Lab1-repo>.git main --squash
   ```
2. If staff update the lab after you've started:
   ```bash
   git subtree pull --prefix=labs/lab1 https://github.com/ELEC50010-IAC/<Lab1-repo>.git main --squash
   ```
   Commit your own work first; the pull merges with your changes.
3. Build with `make` inside the lab folder. Generated `obj_dir/` and `*.vcd` are gitignored.
4. View waveforms: `surfer trace.vcd` (or `gtkwave trace.vcd`).

## macOS quirks on this machine

- `SDKROOT` is pinned to `MacOSX26.sdk` in `~/.zshrc`. Without it, `xcrun` picks a stray
  `MacOSX27.0` beta SDK that the installed linker can't read, and every Verilator build
  fails with `tapi error: ... unknown architecture arm64e.x1`.
- GTKWave is the discontinued x86 build and needs Rosetta. Surfer is the native alternative.
