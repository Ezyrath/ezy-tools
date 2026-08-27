# ezy-tools

Ezyrath personal tools & development shells unified in a Nix Flake.

## Development Shells
- `dev`: Full development environment (Rust, C++, Java, Node, Sway, etc.)
- `unreal`: Unreal Engine environment with CUDA support
- `godot`: Godot engine build environment
- `jetbrains`: JetBrains IDEs & SDKs environment
- `empty`: Clean minimal environment

## Usage
```bash
# Run a specific shell
nix develop .#dev
nix develop .#unreal
nix develop .#godot

# Or using the helper script
ezy_nix_shell run dev
```
