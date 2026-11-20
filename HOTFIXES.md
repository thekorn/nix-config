# Hotfixes

These are workarounds for broken or failing builds: packages that moved to Homebrew, overrides, patches, vendored or pinned packages, and packages turned off. Remove an entry once its fix is no longer needed.

## Moved to Homebrew

| Package | Since | Where | Reason |
| --- | --- | --- | --- |
| swiftformat | 2026-11-20 | `home/shared/common.packages.nix`, `hosts/darwin/shared/homebrew.common.nix` | On Darwin, the Nix build fails because swift-collections won't link (install_name_tool headerpad). Linux still installs it from Nix. |
| mpv | 2026-11-20 | `home/shared/programs/mpv.nix`, `hosts/darwin/shared/homebrew.common.nix` | Building it needs Swift, which fails on Darwin. On Darwin, `play-ls` runs `mpv` from `PATH`. |
| container | – | `hosts/darwin/shared/homebrew.common.nix`, `pkgs/vendored/container.nix` | The vendored Nix version is still broken. |
| 1password | – | `hosts/darwin/shared/homebrew.common.nix`, `home/shared/programs/1password.nix` | The Nix version is marked as broken. |

## Overrides and patches

| Package | Since | Where | Reason |
| --- | --- | --- | --- |
| codebook | 2026-11-09 | `home/shared/programs/codebook.nix` | Adds `pkg-config` and `aws-lc` because the build now needs the system AWS-LC library. Remove this once nixpkgs supplies them. |
| atuin | 2026-11-06 | `home/shared/programs/atuin.nix`, `pkgs/vendored/atuin-isolate-test-processes.patch` | On Darwin, the patch isolates test processes, for versions 18.24.4 and 18.24.5 only. Revisit after 18.24.5. |
| ccache | 2026-10-26 | `home/shared/devel/ladybird.nix` | On Darwin, the override drops `elfutils` from the check inputs and silences unused Clang flags so the tests pass. |
| tmux34 | – | `pkgs/vendored/tmux34.nix` | tmux 3.4 is pinned because tmux 3.5a on unstable always runs `/bin/sh`. |

## Disabled

| Package | Where | Reason |
| --- | --- | --- |
| yt-dlp | `home/shared/programs/mpv.nix` | The build has been broken since 2026-02-23. |
| workmux | `home/shared/programs/workmux.nix` | The build is broken and its tests fail. |
| NixOS documentation | `hosts/linux/shared/home.private.nix` | The doc build fails with `Failed to render option services.seerr.stateRevision`. |

## Upstream changes

| Package | Since | Where | Change |
| --- | --- | --- | --- |
| hunk | 2026-11-09 | `flake.nix`, `home/shared/programs/hunk.nix` | Dropped the vendored prebuilt package and the `v0.20.1` pin. The config now tracks upstream `main` through its Home Manager module. |
| codexbar, tinycast casks | 2026-11-09 | `hosts/darwin/shared/homebrew.common.nix` | Switched to the official cask names and removed the `steipete/tap` and `abue-ammar/tinycast` taps. |
