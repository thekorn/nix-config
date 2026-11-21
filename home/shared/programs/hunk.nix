{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf (config.custom.git.enable && !config.custom.git.server) {
    home.packages = [pkgs.hunk];

    xdg.configFile."hunk/config.toml".source = (pkgs.formats.toml {}).generate "hunk-config.toml" {
      theme = "github-dark-default";
      mode = "split";
      line_numbers = true;
    };
  };
}
