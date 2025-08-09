# NixOS private profile
{
  pkgs,
  users,
  ...
}: {
  imports = [
    ../../hosts/linux/shared/home.private.nix
  ];
}