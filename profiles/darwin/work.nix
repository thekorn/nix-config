{
  pkgs,
  users,
  ...
}: {
  imports = [
    ../../modules/darwin-base.nix
    ../../hosts/darwin/shared/homebrew.common.nix
    ../../hosts/darwin/shared/homebrew.work.nix
    ../../hosts/darwin/shared/fonts.nix
    (import ../../hosts/darwin/shared/preferences.nix {
      inherit pkgs;
      username = users.work;
    })
  ];

  ids.gids.nixbld = 30000;
}