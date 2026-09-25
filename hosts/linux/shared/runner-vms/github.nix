{
  config,
  lib,
  ...
}: {
  imports = [./base.nix];

  # A newly provisioned VM should boot cleanly before its tokens are installed.
  systemd.services = lib.mapAttrs' (name: runner:
    lib.nameValuePair "github-runner-${name}" {
      unitConfig.ConditionPathExists = runner.tokenFile;
    }) (lib.filterAttrs (_: runner: runner.enable) config.services.github-runners);
}
