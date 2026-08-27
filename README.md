# ezy-tools

Personal tools, helper scripts, and development shells unified in a Nix Flake.

---

## 📜 Scripts (`bin/`)

The repository provides several CLI utilities located in [`bin/`](./bin):

### 1. `ezy_dev`
Manages development toolchains, installations, and launches isolated Nix FHS environments.

| Command | Description |
| :--- | :--- |
| `ezy_dev install [-y]` | Installs Rust (via `rustup`), SpacetimeDB CLI, Antigravity CLI (`agy`), Antigravity 2, Antigravity IDE, and cargo utilities (`cbindgen`, `cargo-edit`, `cargo-make`). |
| `ezy_dev update` | Updates all installed toolchains, SpacetimeDB, Antigravity suites, and cargo tools. |
| `ezy_dev shell` | Spawns the `dev` Nix development shell (`.#dev`). |
| `ezy_dev sandbox [CMD]` | Enters an isolated Nix Level 2 FHS sandbox with an isolated `HOME` directory (`~/.local/share/ezy_dev_sandbox/home`), keeping your real `~/.ssh` and sensitive configurations fully hidden and protected. |

---

### 2. `ezy_nix_shell`
CLI manager for Nix Flake development shells.

| Command | Description |
| :--- | :--- |
| `ezy_nix_shell list` | Lists all available development environments in the flake. |
| `ezy_nix_shell run [NAME] [ARGS...]` | Enters a specific dev shell (e.g. `dev`, `unreal`, `godot`, `jetbrains`, `empty`). Defaults to `dev`. |
| `ezy_nix_shell install [NAME]` | Generates a standalone `shell.nix` in the current working directory referencing the selected environment. |

---

### 3. `ezy_unreal`
Unreal Engine source manager, build automation, and project workflow helper.

| Command | Description |
| :--- | :--- |
| `ezy_unreal list` | Lists all installed Unreal Engine versions/commits under `~/.local/share/unreal-engine`. |
| `ezy_unreal install <COMMIT>` | Clones and compiles Unreal Engine from source for the specified Git commit, tag, or branch. |
| `ezy_unreal delete <COMMIT>` | Deletes the specified engine build and cleans engine association in `Install.ini`. |
| `ezy_unreal run <COMMIT>` | Runs Unreal Editor for the specified version (loads project if a `.uproject` is in the current directory). |
| `ezy_unreal launch <COMMIT>` | Compiles the project development target (`make <Project>Editor-Linux-Development`) and starts Unreal Editor. |
| `ezy_unreal generate <COMMIT>` | Generates project files, updates engine association, patches VS Code launch configurations for LLDB, and creates `compile_commands.json` for Zed / clangd. |
| `ezy_unreal verify <COMMIT>` | Runs a headless compile check of all Blueprints in the project (`-run=CompileAllBlueprints -unattended -NullRHI`). |

---

### 4. `ezy_sync`
Interactive, safe file synchronization helper using `rclone`.

- Prompts securely for `RCLONE_CONFIG_PASS`.
- Performs a preliminary check with `rclone check`.
- Requires explicit user confirmation before running an optimized, parallelized `rclone sync` (`--drive-chunk-size 128M`, `--transfers 8`, etc.).
- Performs a post-sync verification check.

**Usage:**
```bash
ezy_sync <SOURCE> <DESTINATION>
```

---

### 5. `ezy_kde`
Simplified session management utility for KDE Plasma.

| Command | Description |
| :--- | :--- |
| `ezy_kde close` | Gracefully closes the active KDE session via DBus (`qdbus org.kde.ksmserver /KSMServer logout 0 0 0`). |
| `ezy_kde help` | Displays help message. |

---

### 6. `chrome`
Convenience wrapper script to launch Google Chrome via Flatpak:
```bash
chrome [ARGS...]
```

---

## 🛠 Development Shells (`shells/`)

Available development environments defined in the flake:

- **`dev`**: Full development environment (Rust, C++, Java, Node.js, Sway/Wayland libs, `wl-inject`, etc.).
- **`unreal`**: Unreal Engine FHS build & runtime environment with CUDA support.
- **`godot`**: Build environment for Godot Engine development.
- **`jetbrains`**: JetBrains IDEs & SDKs environment.
- **`empty`**: Clean, minimal development shell.

---

## 🚀 Usage

### Entering a development shell
```bash
# Using nix develop directly
nix develop .#dev
nix develop .#unreal
nix develop .#godot

# Or using the helper script
ezy_nix_shell run dev
ezy_nix_shell run unreal
```

### Installing the tools
```bash
# Install packages into your profile
nix profile install .

# Or run directly via flake
nix run .#dev
```

