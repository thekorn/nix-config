{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  cfg = config.custom.rex;

  # The sessionizer searches the same directories as the tmux sessionizer.
  sessionizerVars = config.programs.zsh.sessionVariables;
  words = name: default:
    lib.filter (word: word != "") (lib.splitString " " (toString (sessionizerVars.${name} or default)));
  sessionizer = {
    fd = lib.getExe pkgs.fd;
    dirs = words "TMUX_SESSIONIZER_DIRS" "${config.home.homeDirectory}/Developer";
    extra_dirs = words "TMUX_SESSIONIZER_EXTRA_DIRS" "";
    depth = lib.toInt (toString (sessionizerVars.TMUX_SESSIONIZER_DEPTH or 2));
    git_only = (sessionizerVars.TMUX_SESSIONIZER_GIT_ONLY or "") != "";
  };
in {
  imports = [
    inputs.rex.homeManagerModules.default
  ];

  options.custom.rex.enable = lib.mkEnableOption "Rex";

  config.programs.rex = {
    inherit (cfg) enable;
    # On macOS, the Rex app ships the rex command and runs the server.
    package = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin null;
    # The guard is added through programs.ssh; skip it where home-manager does not manage ~/.ssh/config.
    sshGuard = lib.mkDefault (pkgs.stdenv.hostPlatform.isLinux && config.programs.ssh.enable);
    config = ''
      require("sessionizer").setup(${lib.generators.toLua {} sessionizer})
      rex.bind("cmd+o", "sessionizer")
      rex.bind("shift+cmd+o", "sessionizer", { dir = "~/.config/nix" })
    '';
  };

  config.xdg.configFile."rex/sessionizer.lua" = lib.mkIf cfg.enable {
    source = ./dotfiles/rex/sessionizer.lua;
  };
}
