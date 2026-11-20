{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  cfg = config.custom.rex;
in {
  imports = [
    inputs.rex.homeManagerModules.default
  ];

  options.custom.rex.enable = lib.mkEnableOption "Rex";

  config.programs.rex = {
    enable = cfg.enable && pkgs.stdenv.hostPlatform.isLinux;
    # The guard is added through programs.ssh; skip it where home-manager does not manage ~/.ssh/config.
    sshGuard = lib.mkDefault config.programs.ssh.enable;
  };
}
