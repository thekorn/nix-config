# custom rpi image

## build

```bash
 $ nix-build '<nixpkgs/nixos>' -A config.system.build.sdImage -I nixos-config=./sd-image.nix
```
