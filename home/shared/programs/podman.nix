{
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [
    podman
    #podman-desktop
    #podman-tui
  ];

  #programs.zsh = {shellAliases = {"docker" = "podman";};};
  # alias is not enough, bunte and ctf local service need docker to be in path
  home.file.".local/bin/docker".source = config.lib.file.mkOutOfStoreSymlink /etc/profiles/per-user/${config.home.username}/bin/podman;
}
