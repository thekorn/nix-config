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
      # FIXME: remove - workaround for test failure (2026-10-24)
      package =
        if pkgs.stdenv.hostPlatform.isDarwin && pkgs.atuin.version == "18.24.2"
        then
          pkgs.atuin.overrideAttrs (old: {
            # These Pi resume tests depend on the host process table and can
            # mistake an unrelated/unreadable process for a live session on macOS.
            # Keep the other tests and revisit this workaround on the next release.
            checkFlags =
              (old.checkFlags or [])
              ++ [
                "--skip=a_copy_behind_another_machine_catches_up_as_it_resumes::agent_3_Agent__Pi"
                "--skip=a_diverged_copy_resumes_only_as_chosen::agent_3_Agent__Pi"
                "--skip=a_session_gone_on_with_elsewhere_catches_up_where_it_came_from::agent_2_Agent__Pi"
              ];
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
