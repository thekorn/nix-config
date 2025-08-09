{
  pkgs,
  users,
  ...
}: {
  imports = [
    ../../profiles/darwin/work.nix
    ./shared/home.work.nix
  ];
}
