# Darwin work profile
{
  pkgs,
  users,
  ...
}: {
  imports = [
    ../../hosts/darwin/shared/homebrew.common.nix
    ../../hosts/darwin/shared/homebrew.work.nix
    ../../hosts/darwin/shared/fonts.nix
    (import ../../hosts/darwin/shared/preferences.nix {
      inherit pkgs;
      username = users.work;
    })
    ../../hosts/darwin/shared/home.work.nix
  ];

  ids.gids.nixbld = 30000;
}