{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf (config.custom.git.commitMessageTool == "gptcommit") {
    home.file = {".config/gptcommit/gptcommit.env".source = ./dotfiles/gptcommit/gptcommit.env;};
    home.file = {".config/gptcommit/config.toml".source = ./dotfiles/gptcommit/gptcommit.toml;};
    home.packages = with pkgs; [
      _1password-cli
      #(pkgs.callPackage ./vendor/gptcommit.thekorn.nix {inherit (pkgs.darwin.apple_sdk.frameworks) Security SystemConfiguration;})
      gptcommit
    ];
    programs.git.hooks.prepare-commit-msg = ./bin/git-prepare-commit-msg;
  };
}
