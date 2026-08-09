{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf (config.custom.git.enable && !config.custom.git.server && config.custom.git.commitMessageTool == "gptcommit") {
    home.file = {
      ".config/gptcommit/gptcommit.env".source = ./dotfiles/gptcommit/gptcommit.env;
      ".config/gptcommit/config.toml".source = ./dotfiles/gptcommit/gptcommit.toml;
    };
    home.packages = with pkgs; [
      _1password-cli
      #vendored.gptcommit-thekorn
      gptcommit
    ];
    programs.git.hooks.prepare-commit-msg = ./bin/git-prepare-commit-msg;
  };
}
