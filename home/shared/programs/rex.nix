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

  # ssh runs commands in a non-interactive shell without the Rex app's REX_BIN_DIR,
  # so point it at the rex command the app installs.
  config.programs.zsh.envExtra = lib.mkIf (cfg.enable && pkgs.stdenv.hostPlatform.isDarwin) ''
    : "''${REX_BIN_DIR:=$HOME/Library/Application Support/com.superlogical.rex/RexServer/Versions/Current/Rex Server.app/Contents/MacOS}"
    if [ -d "$REX_BIN_DIR" ]; then
      export REX_BIN_DIR
      export PATH="$REX_BIN_DIR:$PATH"
    fi
  '';

  # Nix resets PATH at shell startup, dropping the rex directory the Rex app adds.
  config.programs.zsh.initContent = lib.mkIf cfg.enable (lib.mkAfter ''
    if [ -n "$REX_BIN_DIR" ]; then
      export PATH="$REX_BIN_DIR:$PATH"
    fi
  '');

  config.xdg.configFile."rex/sessionizer.lua" = lib.mkIf cfg.enable {
    source = ./dotfiles/rex/sessionizer.lua;
  };
}
