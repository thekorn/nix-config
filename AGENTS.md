# Nix configuration repo managing multi-machine environments via flakes, nix-darwin, and home-manager.

## Commands

- Format: `nix fmt`
- Build darwin: `darwin-rebuild switch --flake .#<hostname>`
- Build linux: `nixos-rebuild switch --flake .#thekorn-server`

## Hosts

- Darwin: `thekorn-macbook`, `thekorn-studio`, `BFG-024849` (user: `d438477`)
- Linux: `thekorn-server`

See [docs/architecture.md](docs/architecture.md) for structure details.
