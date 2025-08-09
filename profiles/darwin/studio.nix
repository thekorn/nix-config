{
  pkgs,
  users,
  ...
}: {
  imports = [
    ../../hosts/darwin/shared/homebrew.studio.nix
    ../../hosts/darwin/shared/homebrew.ladybird.nix
  ];
}