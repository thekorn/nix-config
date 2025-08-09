{
  pkgs,
  users,
  ...
}: {
  imports = [
    ../../profiles/darwin/private.nix
    ../../profiles/darwin/studio.nix
    ./shared/home.private.nix
  ];
}
