# Architecture

## Directory Structure

- **`flake.nix`**: Entry point with `mkDarwinHost` and `mkNixOSHost` helpers that eliminate boilerplate
- **`profiles/`**: Composable role-based modules (home-manager level)
  - `darwin-desktop.nix`: Full desktop setup for macOS (packages, programs, devel dirs)
  - `linux-server.nix`: Headless server setup (server packages, ssh-agent)
  - `work.nix`: Work-specific settings (Jira, monorepo vars)
- **`hosts/`**: System-level configurations (nix-darwin / NixOS)
  - `darwin/shared/base.nix`: Common darwin base (zsh, environment, fonts, preferences, homebrew)
  - `darwin/<machine>.nix`: Per-machine darwin overrides
  - `linux/<machine>.nix`: Per-machine NixOS configs
  - `shared/certificates.nix`: Cross-platform certificate config
- **`home/`**: Per-machine home-manager entry points (import profiles + machine-specific packages)
  - `shared/`: Low-level shared modules (packages, programs, session vars)

## How It Fits Together

```
flake.nix
  └─ mkDarwinHost / mkNixOSHost (handles home-manager wiring, specialArgs)
       ├─ hosts/<platform>/<machine>.nix  (system config)
       │    └─ hosts/<platform>/shared/base.nix  (common system base)
       └─ home/<machine>.nix  (home-manager config)
            └─ profiles/<role>.nix  (composable roles)
                 └─ home/shared/*  (individual programs & packages)
```

## Adding a New Machine

1. Create `hosts/<platform>/<machine>.nix` — import `shared/base.nix` + machine-specific modules
2. Create `home/<machine>.nix` — import relevant profiles + machine-specific packages
3. Add a `mkDarwinHost` / `mkNixOSHost` call in `flake.nix`

## Adding a New Profile

Create a file in `profiles/` that imports the relevant `home/shared/*` modules. Then add it to any machine's `home/<machine>.nix` imports.

## Key Design Decisions

- `primaryUser` is passed via `specialArgs` — available to all system and home-manager modules
- User home directory is derived automatically in `base.nix` from `primaryUser`
- `mkDarwinHost` / `mkNixOSHost` handle all home-manager integration boilerplate
- Uses `nixpkgs-unstable` channel, allows unfree packages globally
- Formatter is `alejandra` for consistent Nix code style
