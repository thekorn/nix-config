{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  nvimConfig = pkgs.lib.cleanSourceWith {
    src = inputs.config-nvim;
    filter = path: type: baseNameOf path != "nvim-pack-lock.json";
  };

  packLockPath = "${config.xdg.stateHome}/nvim/nvim-pack-lock.json";
in {
  home.packages = [pkgs.neovim];

  xdg.configFile."nvim" = {
    source = nvimConfig;
    recursive = true;
  };

  xdg.configFile."nvim/nvim-pack-lock.json".source =
    config.lib.file.mkOutOfStoreSymlink packLockPath;

  home.activation.seedNvimPackLock = lib.hm.dag.entryAfter ["writeBoundary"] ''
    if [ ! -e ${lib.escapeShellArg packLockPath} ]; then
      $DRY_RUN_CMD mkdir -p ${lib.escapeShellArg (dirOf packLockPath)}
      $DRY_RUN_CMD cp ${lib.escapeShellArg "${inputs.config-nvim}/nvim-pack-lock.json"} ${lib.escapeShellArg packLockPath}
      $DRY_RUN_CMD chmod u+w ${lib.escapeShellArg packLockPath}
    fi
  '';
}
