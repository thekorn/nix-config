{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.custom.atuin;
in {
  options.custom.atuin.enable = lib.mkEnableOption "atuin";
  config = lib.mkIf cfg.enable {
    #programs.zsh = {initContent = ''eval "$(atuin init zsh)"'';};
    programs.atuin = {
      enable = true;
      # FIXME: revisit this test-isolation patch on the next Atuin release.
      package =
        if pkgs.stdenv.hostPlatform.isDarwin && pkgs.atuin.version == "18.24.4"
        then
          pkgs.atuin.overrideAttrs (old: {
            # Keep the Pi resume tests running without letting unrelated macOS
            # processes make their fake sessions look live. Production checks
            # are unchanged: the override requires Atuin's test-utils feature.
            patches = (old.patches or []) ++ [../../../pkgs/vendored/atuin-isolate-test-processes.patch];
            # PTY tests fork while socket tests drop listeners. An inherited
            # descriptor can keep a supposedly stale socket alive until exec.
            dontUseCargoParallelTests = true;
          })
        else pkgs.atuin;
      settings = {
        style = "compact";
        enter_accept = true;
      };
      enableZshIntegration = true;
    };
  };
}
