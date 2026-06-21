# Architecture

## Directory Structure

- **`flake/`**: Flake-parts modules. This is the top-level dendritic tree for flake outputs: shared flake helpers, per-system outputs, deploy apps, and host output registration live in separate branches.
- **`hosts/`**: Per-machine entry points. Each host owns both its system configuration and the home-manager profile for its primary user.
  - `darwin/shared/`: Shared macOS system modules (fonts, homebrew, preferences)
  - `linux/shared/`: Shared Linux system modules
- **`home/shared/`**: Reusable home-manager modules only. Host files compose these modules into machine-specific user profiles.
  - `profiles/`: Higher-level home bundles such as `darwin.nix` and `linux-server.nix`
  - `programs/`: Program-specific home-manager modules

## Flake-Parts / Dendritic Layout

`flake.nix` is now only the input declaration and `flake-parts.lib.mkFlake` entry point. The actual flake outputs are composed by the dendritic import tree under `flake/`:

| Module | Purpose |
|--------|---------|
| `flake/default.nix` | Branch module that imports the flake leaves |
| `flake/lib.nix` | Shared flake-level values: users, `specialArgs`, host metadata, pkgs import policy, and Darwin/NixOS host builders |
| `flake/per-system.nix` | System-specific outputs and defaults, currently the formatter and configured `pkgs` |
| `flake/deploy.nix` | Deploy packages and apps for remote NixOS hosts |
| `flake/hosts.nix` | Public `darwinConfigurations` and `nixosConfigurations` outputs |

This keeps each flake concern close to one file while preserving the existing host/home module boundaries.

## Shared Configuration Modules

| Module | Purpose |
|--------|---------|
| `common.nix` | Base session variables and paths |
| `common.packages.nix` | Core CLI tools and applications |
| `common.programs.nix` | Imports all program-specific configurations |
| `common.darwin.nix` / `common.linux.nix` | Platform-specific settings |
| `devel.nix` | Development packages and tools |
| `work.nix` | Work-specific configurations |

## Home Profiles

Home-manager is wired by the host module, not by `flake.nix`. Shared profile modules provide reusable bundles:

| Profile | Purpose |
|---------|---------|
| `home/shared/profiles/darwin.nix` | Common macOS home setup: base shell env, packages, programs, and development folders |
| `home/shared/profiles/linux-server.nix` | Common Linux server home setup: base env, server packages/programs, SSH agent, and state version |

Host modules then add role- or machine-specific modules:

- private machines add `home/shared/private.nix`
- work machines add `home/shared/work.nix`
- individual machines add their extra packages and custom options inline in the host file

## Program Configuration Pattern

Each program has its own module in `home/shared/programs/` (e.g., `git.nix`, `zsh.nix`, `nvim.nix`) with:
- Program-specific Nix options
- Custom scripts and functions
- Dotfiles referenced from `dotfiles/` subdirectory

## Machine-Specific Composition

Each machine now has a single machine-specific file under `hosts/`. That file imports system modules and configures home-manager for the machine's primary user:

```nix
imports = [
  ./shared/homebrew.common.nix
  ./shared/home.private.nix
  ./shared/fonts.nix
];

home-manager.users.${users.private} = {pkgs, ...}: {
  imports = [
    ../../home/shared/profiles/darwin.nix
    ../../home/shared/private.nix
  ];

  home.packages = with pkgs; [
    discord
  ];
};
```

`flake.nix` stays intentionally small: it declares inputs, enters flake-parts, and imports the dendritic flake module tree. The reusable Darwin/NixOS builders, home-manager defaults, and host output registry live under `flake/`.

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
