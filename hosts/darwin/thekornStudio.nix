{users, ...}: {
  imports = [
    ./shared/base.nix
    ./shared/homebrew.studio.nix
    ./shared/homebrew.private.nix
    ./shared/homebrew.ladybird.nix
  ];

  nix.enable = false;
  # this is a bug, remove once https://github.com/nix-community/home-manager/issues/8291 is fixed
  users.users.${users.private}.uid = 501;
}
