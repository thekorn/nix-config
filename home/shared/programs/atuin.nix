{
  config,
  lib,
  ...
}: let
  cfg = config.custom.atuin;
in {
  options.custom.atuin.enable = lib.mkEnableOption "atuin";
  config = lib.mkIf cfg.enable {
    #programs.zsh = {initContent = ''eval "$(atuin init zsh)"'';};
    programs.atuin = {
      enable = true;
      settings = {
        style = "compact";
        enter_accept = true;
      };
      enableZshIntegration = true;
    };
  };
}
