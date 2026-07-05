{
  config,
  lib,
  userName,
  userHome,
  ...
}: {
  imports = [
    ../../../../home/shared/programs/eza.nix
    ../../../../home/shared/programs/zsh.common.nix
  ];

  options.microvm.extraZshInit = lib.mkOption {
    type = lib.types.lines;
    default = "";
    description = "Extra lines to add to zsh initContent";
  };

  config = {
    home.username = userName;
    home.homeDirectory = userHome;

    programs.zsh.initContent = lib.mkAfter ''
      ${config.microvm.extraZshInit}
    '';

    home.stateVersion = "25.11";
    programs.home-manager.enable = true;
  };
}
