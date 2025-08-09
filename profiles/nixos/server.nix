{
  pkgs,
  users,
  ...
}: {
  imports = [
    ../../modules/nixos-base.nix
    ../../hosts/shared/certificates.nix
  ];

  services.tailscale.enable = false;
}