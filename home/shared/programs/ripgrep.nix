{
  config,
  lib,
  ...
}: let
  cfg = config.custom.ripgrep;
in {
  options.custom.ripgrep.enable = lib.mkEnableOption "ripgrep";
  config.programs.ripgrep = lib.mkIf cfg.enable {
    enable = true;
    arguments = [
      "--max-columns=150"
      "--max-columns-preview"

      # Add my 'web' type.
      "--type-add"
      "web:*.{html,css,js}*"

      # Add my 'ts' type.
      "--type-add"
      "ts:*.{ts,tsx,vue}"

      # Because who cares about case!?
      "--smart-case"
    ];
  };
}
