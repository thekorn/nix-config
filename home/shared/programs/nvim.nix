{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  nvimConfig = pkgs.lib.cleanSourceWith {
    src = inputs.config-nvim;
    filter = path: type: baseNameOf path != "lazy-lock.json";
  };

  lazyLockPath = "${config.xdg.stateHome}/nvim/lazy-lock.json";
in {
  home.packages = [pkgs.neovim];

  xdg.configFile."nvim" = {
    source = nvimConfig;
    recursive = true;
  };

  xdg.configFile."nvim/lazy-lock.json".source =
    config.lib.file.mkOutOfStoreSymlink lazyLockPath;

  home.activation.seedNvimLazyLock = lib.hm.dag.entryAfter ["writeBoundary"] ''
    if [ ! -e ${lib.escapeShellArg lazyLockPath} ]; then
      $DRY_RUN_CMD mkdir -p ${lib.escapeShellArg (dirOf lazyLockPath)}
      $DRY_RUN_CMD cp ${lib.escapeShellArg "${inputs.config-nvim}/lazy-lock.json"} ${lib.escapeShellArg lazyLockPath}
      $DRY_RUN_CMD chmod u+w ${lib.escapeShellArg lazyLockPath}
    fi
  '';
}
