# Architecture

## Directory Structure

- **`hosts/`**: System-level configurations (nix-darwin for macOS, NixOS for Linux)
  - `darwin/shared/`: Shared macOS system modules (fonts, homebrew, preferences)
  - `linux/shared/`: Shared Linux system modules
- **`home/`**: User-level home-manager configurations
  - `shared/`: Shared user modules organized by function
  - `thekorn*.nix`: Per-machine user configurations

## Shared Configuration Modules

| Module | Purpose |
|--------|---------|
| `common.nix` | Base session variables and paths |
| `common.packages.nix` | Core CLI tools and applications |
| `common.programs.nix` | Imports all program-specific configurations |
| `common.darwin.nix` / `common.linux.nix` | Platform-specific settings |
| `devel.nix` | Development packages and tools |
| `work.nix` | Work-specific configurations |

## Program Configuration Pattern

Each program has its own module in `home/shared/programs/` (e.g., `git.nix`, `zsh.nix`, `nvim.nix`) with:
- Program-specific Nix options
- Custom scripts and functions
- Dotfiles referenced from `dotfiles/` subdirectory

## Machine-Specific Imports

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

## Homebrew Integration

macOS configurations use Homebrew for packages that don't work well with Nix:
- Base packages in `homebrew.common.nix`
- Machine-specific packages in `homebrew.*.nix` files
- Commonly used for GUI apps, Docker, and other problematic packages

## Development Notes

- Uses `nixpkgs-unstable` channel for latest packages
- Allows unfree packages globally (`allowUnfree = true`)
- Formatter is `alejandra` for consistent Nix code style
- Primary user is "thekorn" except on work machine ("d438477")
- Git configurations change based on repository location (work vs personal repos)
