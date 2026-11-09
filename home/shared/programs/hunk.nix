{
  config,
  inputs,
  lib,
  ...
}: {
  imports = [
    inputs.hunk.homeManagerModules.default
  ];

  config.programs.hunk = lib.mkIf (config.custom.git.enable && !config.custom.git.server) {
    enable = true;
    enableGitIntegration = false;
    settings = {
      theme = "github-dark-default";
      mode = "split";
      line_numbers = true;
    };
  };
}
