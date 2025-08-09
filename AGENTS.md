# AGENTS.md - Nix Configuration Repository

## Build/Test Commands
- **Build Darwin config**: `nix build .#darwinConfigurations.thekorn-studio.system`
- **Switch Darwin config**: `darwin-rebuild switch --flake .#thekorn-studio`
- **Switch NixOS config**: `nixos-rebuild switch --flake .#thekorn-server`
- **Format all Nix files**: `nix fmt` (uses alejandra formatter)
- **Update flake inputs**: `nix flake update`
- **Enter dev shell**: `nix develop`

## Code Style Guidelines
- **Formatter**: Use `alejandra` (configured in flake.nix:60)
- **Imports**: Use `{pkgs, config, lib, ...}:` pattern with explicit parameters
- **Let bindings**: Use `let...in` for complex expressions and helper functions
- **Naming**: Use kebab-case for files/directories, camelCase for Nix attributes
- **Comments**: Use `#` for inline comments, avoid block comments
- **Strings**: Use double quotes for strings, single quotes for shell scripts in writeShellScriptBin
- **Indentation**: 2 spaces (enforced by alejandra)
- **Attribute sets**: Use explicit attribute syntax `{ attr = value; }`
- **Module structure**: Separate concerns into individual .nix files under appropriate directories
- **Error handling**: Prefer explicit error messages in assertions and conditionals