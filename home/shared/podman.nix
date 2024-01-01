{ pkgs, ... }: {
  #home.packages = with pkgs; [ podman qemu ];

  programs.zsh = { shellAliases = { "docker" = "podman"; }; };
}
