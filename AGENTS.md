# Nix configuration repo managing multi-machine environments via flakes, nix-darwin, and home-manager.

## Commands

- Format: `nix fmt .`
- Build darwin: `darwin-rebuild switch --flake .#<hostname>`
- Build linux: `nixos-rebuild switch --flake .#thekorn-server`

## Hosts

- Darwin: `thekorn-macbook`, `thekorn-studio`, `M-G19X71XW4W` (user: `d438477`)
- Linux: `thekorn-server`

## Hotfixes

- Whenever you work around a broken build, such as moving a package to Homebrew, adding an override or patch, vendoring or pinning a package, or turning a package off, add an entry to [HOTFIXES.md](HOTFIXES.md). When you remove the workaround, remove its entry too.

See [docs/architecture.md](docs/architecture.md) for structure details.
