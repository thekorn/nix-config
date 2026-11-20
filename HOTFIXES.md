# Hotfixes

These are workarounds for broken or failing builds: packages that moved to Homebrew, overrides, patches, vendored or pinned packages, and packages turned off. Remove an entry once its fix is no longer needed.

## Moved to Homebrew

| Package | Since | Where | Reason |
| --- | --- | --- | --- |
| swiftformat | 2026-11-20 | `home/shared/common.packages.nix`, `hosts/darwin/shared/homebrew.common.nix` | On Darwin, the Nix build fails because swift-collections won't link (install_name_tool headerpad). Linux still installs it from Nix. |
| mpv | 2026-11-20 | `home/shared/programs/mpv.nix`, `hosts/darwin/shared/homebrew.common.nix` | Building it needs Swift, which fails on Darwin. On Darwin, `play-ls` runs `mpv` from `PATH`. |
| container | – | `hosts/darwin/shared/homebrew.common.nix`, `pkgs/vendored/container.nix` | The nixpkgs `container` (1.5.0) fails to build on Darwin with the same swift-collections link error as swiftformat. The vendored 1.2.2 build in `pkgs/vendored/container.nix` still builds but is not installed (commented out in `home/shared/common.darwin.nix`). |
| 1password | – | `hosts/darwin/shared/homebrew.common.nix`, `home/shared/programs/1password.nix` | The Nix version used to be marked as broken. As of 2026-11-20, `_1password-gui` 8.12.46 builds. The cask stays until switching is decided, because 1Password expects to run from `/Applications`, so the swap would need nix-darwin's `programs._1password-gui`. |

## Overrides and patches

None at the moment. Use the columns Package, Since, Where, and Reason.

## Disabled

| Package | Where | Reason |
| --- | --- | --- |
| NixOS documentation | `hosts/linux/shared/home.private.nix` | The doc build fails with `Failed to render option services.seerr.stateRevision`. |

## Upstream changes

| Package | Since | Where | Change |
| --- | --- | --- | --- |
| hunk | 2026-11-09 | `flake.nix`, `home/shared/programs/hunk.nix` | Dropped the vendored prebuilt package and the `v0.20.1` pin. The config now tracks upstream `main` through its Home Manager module. |
| codexbar, tinycast casks | 2026-11-09 | `hosts/darwin/shared/homebrew.common.nix` | Switched to the official cask names and removed the `steipete/tap` and `abue-ammar/tinycast` taps. |
