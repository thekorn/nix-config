---
name: check-hotfixes
description: "Manages HOTFIXES.md, the list of build workarounds in this Nix config: packages moved to Homebrew, overrides, patches, vendored or pinned packages, and disabled packages. Use when adding or removing a workaround, or when asked to \"check hotfixes\", which tests every hotfix against the locked nixpkgs and removes the ones no longer needed."
---

# Check hotfixes

`HOTFIXES.md` at the repository root lists every workaround that keeps the builds green. Each entry names the package, the date it was added, the files it touches, and why it exists. The tables are:

- **Moved to Homebrew**: the package comes from Homebrew on Darwin instead of Nix.
- **Overrides and patches**: `overrideAttrs`, extra patches, and vendored or pinned packages.
- **Disabled**: the package or feature is commented out or turned off.
- **Upstream changes**: changes to upstream inputs or Homebrew taps. These record history and are not checked.

## Adding or removing an entry

When you add a workaround, add a row to the matching table. Include the date (`YYYY-MM-DD`), every file the workaround touches, and the error that made it necessary. Put a short comment in the Nix file at the workaround as well. When you remove a workaround, delete its row in the same change.

## "check hotfixes"

Go through every entry outside the "Upstream changes" table and decide whether it is still needed against the nixpkgs revision in `flake.lock`. Do not run `nix flake update` unless the user asks; check the locked revision.

Darwin evaluations use this machine's host: `HOST=$(scutil --get LocalHostName)`. Its package set, with the repository overlays applied, is `.#darwinConfigurations.$HOST.pkgs`.

### 1. Test each entry

Build the unmodified package. Do not change any files yet.

| Kind | Test |
| --- | --- |
| Moved to Homebrew, or disabled | `nix build --no-link -L .#darwinConfigurations.$HOST.pkgs.<attr>`. A flake input package such as workmux is `inputs.<name>.packages.<system>.default`; build it with `nix build --no-link -L github:<owner>/<repo>` or through the locked input. |
| `overrideAttrs` or patch | Build the stock attribute as above. For a version-gated workaround, such as atuin, first check `nix eval --raw .#darwinConfigurations.$HOST.pkgs.<attr>.version`. If the version is no longer in the gated list, the workaround is already inactive and can be removed. |
| Vendored or pinned (tmux34) | Check whether the reason still holds against the current nixpkgs version. For tmux, the question is whether it still always runs `/bin/sh`. Read the upstream package or changelog, then build. |
| Linux-only (NixOS documentation) | Build the manual with documentation turned back on: `nix build --no-link -L "$(nix eval --raw .#nixosConfigurations.thekorn-server --apply 'c: (c.extendModules { modules = [{ documentation.enable = c.pkgs.lib.mkForce true; documentation.doc.enable = c.pkgs.lib.mkForce true; documentation.nixos.enable = c.pkgs.lib.mkForce true; }]; }).config.system.build.manual.manualHTML.drvPath')^*"`. This needs an x86_64-linux builder (see `/etc/nix/machines`). If none is available, mark the entry unverifiable and keep it. |

Run independent builds in parallel. Builds can take a long time, so use background commands and check on them. Do not just wait.

A hotfix is **still needed** if the stock build fails. Record the failing log line. A hotfix is **no longer needed** if the stock build succeeds with its checks enabled.

### 2. Remove the hotfixes that are no longer needed

For each such entry:

1. Revert the workaround in every file the entry lists. Restore the plain Nix package, drop the Homebrew brew or cask and any taps it needed, remove `overrideAttrs` or patch files that nothing else uses, and uncomment disabled packages. Keep the surrounding code style. For example, if a package is no longer Darwin-only, remove the `lib.optionals (!isDarwin)` split.
2. Delete its row from `HOTFIXES.md`.

### 3. Verify the whole configuration

- Run `nix fmt .`.
- Run `darwin-rebuild build --flake .#$HOST`. This builds without switching. Do not run `darwin-rebuild switch`, or deploy to any NixOS host, unless the user asks.
- If the full build fails because of a hotfix you removed, restore that hotfix and its row, and report it as still needed.

### 4. Report

List every entry with one of these verdicts:

- **Removed**: the stock build passed.
- **Still needed**: include the error line.
- **Unverifiable here**: say why.

Also mention any entry whose details in `HOTFIXES.md`, such as files, versions, or reason, turned out to be wrong, and correct those details. Leave the changes uncommitted unless the user asks for a commit.
