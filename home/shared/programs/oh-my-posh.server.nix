{
  config,
  lib,
  ...
}: {
  config.programs.oh-my-posh = lib.mkIf (config.custom.zsh.enable && config.custom.zsh.server) {
    enable = true;
    settings = builtins.fromJSON (builtins.readFile ./dotfiles/oh-my-posh/material.omp.json);
  };
}
