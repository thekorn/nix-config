{...}: {
  imports = [
    ./shared/base.nix
    ./shared/homebrew.work.nix
  ];

  ids.gids.nixbld = 30000;
}
