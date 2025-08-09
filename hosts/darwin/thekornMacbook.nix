{
  pkgs,
  users,
  ...
}: {
  imports = [
    ../../profiles/darwin/private.nix
    ./shared/home.private.nix
  ];
}
