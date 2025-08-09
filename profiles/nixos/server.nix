# NixOS server profile
{
  pkgs,
  users,
  ...
}: {
  imports = [
    ../../hosts/shared/certificates.nix
  ];

  services.tailscale.enable = false;
}