{pkgs, ...}: {
  programs.jujutsu = {
    enable = true;
    settings = builtins.fromTOML (builtins.readFile ./dotfiles/jujutsu/config.toml);
  };

  home.packages = with pkgs; [
    jjui
  ];
}
