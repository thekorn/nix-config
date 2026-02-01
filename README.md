# config using nix and flake

This is the multi-machine configuration for my Darwin (macOS) and Linux systems, managed via Nix Flakes, nix-darwin, and home-manager.

## Prerequisites

- **Git**: Required to clone this repository.
- **Homebrew** (Darwin only): Used for managing some macOS applications.

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

- **Nix**: Install Nix with Flakes support.

```bash
curl -fsSL https://install.determinate.systems/nix | sh -s -- install
```

## Setup

1. Clone this repository into `~/.config/nix`:

```bash
git clone https://github.com/thekorn/nix-config.git ~/.config/nix
cd ~/.config/nix
```

2. Apply the configuration for your host:

### Darwin (macOS)

For a first-time installation:
```bash
nix run nix-darwin -- switch --flake .#<hostname>
```

For subsequent updates:
```bash
darwin-rebuild switch --flake .#<hostname>
```

### Linux (NixOS)

```bash
sudo nixos-rebuild switch --flake .#<hostname>
```

## Available Hosts

### Darwin
- `thekorn-macbook` (Personal MacBook)
- `thekorn-studio` (Personal Mac Studio)
- `BFG-024849` (Work Laptop, user: `d438477`)

### Linux
- `thekorn-server` (Main server)
- `thekorn-server2` (Secondary server)

## Maintenance

- **Format code**: `nix fmt`
- **Update inputs**: `nix flake update`

## Reference

- [nix-darwin manual](https://daiderd.com/nix-darwin/manual/index.html)
- [home-manager options](https://nix-community.github.io/home-manager/options.html)
- [Architecture details](./docs/architecture.md)

## TODO:

- Idea: move git commit hooks handling to lefthook https://lefthook.dev