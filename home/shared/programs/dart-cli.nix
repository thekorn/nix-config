{
  config,
  lib,
  ...
}: let
  cfg = config.custom.dartCli;
in {
  options.custom.dartCli.enable = lib.mkEnableOption "Dart CLI shell integration";
  config.programs.zsh = lib.mkIf cfg.enable {
    initContent = ''
      ## [Completion]
      ## Completion scripts setup. Remove the following line to uninstall
      [[ -f ~/.dart-cli-completion/zsh-config.zsh ]] && . ~/.dart-cli-completion/zsh-config.zsh || true
      ## [/Completion]
    '';
  };
}
