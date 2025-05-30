# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Nix configuration repository that manages system and user environments across multiple machines using Nix flakes, nix-darwin, and home-manager. It provides declarative configuration for development environments, dotfiles, and system settings.

## Key Commands

### Building and Switching Configurations

**Darwin (macOS) machines:**
```bash
# Build configuration
nix build .#darwinConfigurations.thekorn-studio.system

# Switch to configuration (common)
darwin-rebuild switch --flake .#thekorn-studio
darwin-rebuild switch --flake .#thekorn-macbook  
darwin-rebuild switch --flake .#BFG-024849

# Initial installation (from README)
sudo nix run nix-darwin/master#darwin-rebuild -- switch --flake ~/.config/nix
```

**Linux machine:**
```bash
# Switch configuration
nixos-rebuild switch --flake .#thekorn-server
```

**Development and maintenance:**
```bash
# Enter development shell
nix develop

# Format all Nix files
nix fmt

# Update flake inputs
nix flake update
```

## Architecture

### Machine Configurations
- **Darwin hosts**: `thekorn-macbook`, `thekorn-studio`, `BFG-024849` (work machine with different username `d438477`)
- **Linux host**: `thekorn-server`
- Each machine has both system config in `hosts/` and user config in `home/`

### Directory Structure
- **`hosts/`**: System-level configurations (nix-darwin for macOS, NixOS for Linux)
  - `darwin/shared/`: Shared macOS system modules (fonts, homebrew, preferences)
  - `linux/shared/`: Shared Linux system modules
- **`home/`**: User-level home-manager configurations
  - `shared/`: Shared user modules organized by function
  - `thekorn*.nix`: Per-machine user configurations

### Shared Configuration Modules
- **`common.nix`**: Base session variables and paths
- **`common.packages.nix`**: Core CLI tools and applications  
- **`common.programs.nix`**: Imports all program-specific configurations
- **`common.darwin.nix`/`common.linux.nix`**: Platform-specific settings
- **`devel.nix`**: Development packages and tools
- **`work.nix`**: Work-specific configurations

### Program Configuration Pattern
Each program has its own module in `home/shared/programs/` (e.g., `git.nix`, `zsh.nix`, `nvim.nix`) with:
- Program-specific Nix options
- Custom scripts and functions
- Dotfiles referenced from `dotfiles/` subdirectory

### Homebrew Integration
macOS configurations use Homebrew for packages that don't work well with Nix:
- Base packages in `homebrew.common.nix`
- Machine-specific packages in `homebrew.*.nix` files
- Commonly used for GUI apps, Docker, and other problematic packages

## Configuration Patterns

### Machine-Specific Imports
Each machine configuration imports shared modules plus machine-specific customizations:
```nix
imports = [
  ../shared/common.nix
  ../shared/common.darwin.nix  # or common.linux.nix
  ../shared/common.packages.nix
  ../shared/common.programs.nix
  ../shared/devel.nix
];
```

### Conditional Git Configuration
Git configurations change based on repository location (work vs personal repos).

### Dotfiles Management
- Program configurations use home-manager options when possible
- Static dotfiles stored in `dotfiles/` and symlinked by home-manager
- All dotfiles are version-controlled as part of the Nix configuration

## Development Notes

- Uses `nixpkgs-unstable` channel for latest packages
- Allows unfree packages globally (`allowUnfree = true`)
- Formatter is `alejandra` for consistent Nix code style
- Primary user is "thekorn" except on work machine ("d438477")