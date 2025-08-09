# Darwin private profile
{
  pkgs,
  users,
  ...
}: {
  imports = [
    ../../hosts/darwin/shared/homebrew.common.nix
    ../../hosts/darwin/shared/homebrew.private.nix
    ../../hosts/darwin/shared/fonts.nix
    (import ../../hosts/darwin/shared/preferences.nix {
      inherit pkgs;
      username = users.private;
    })
    ../../hosts/darwin/shared/home.private.nix
  ];
}