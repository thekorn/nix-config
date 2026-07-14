{
  config,
  pkgs,
  ...
}: {
  programs.herdr = {
    enable = true;
    package = pkgs.llm-agents.herdr;
  };

  programs.ghostty = {
    enable = true;
  };

  home.file.".local/bin/herdr-ghostty" = {
    executable = true;
    text = ''
      #!/bin/bash

      # @raycast.schemaVersion 1
      # @raycast.title Herdr
      # @raycast.mode silent
      # @raycast.packageName Development
      # @raycast.description Launch Herdr in Ghostty

      unset HERDR_ENV
      exec ${config.programs.ghostty.package}/bin/ghostty -e ${config.programs.herdr.package}/bin/herdr
    '';
  };
}
