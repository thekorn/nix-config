{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.custom.git;
  model =
    if cfg.commitMessageModel == null
    then ""
    else cfg.commitMessageModel;
  codexPrepareCommitMessage = pkgs.writeShellApplication {
    name = "codex-prepare-commit-msg";
    runtimeInputs = [
      pkgs.coreutils
      pkgs.git
      pkgs.codex
    ];
    text = ''
      export CODEX_COMMIT_MODEL=${lib.escapeShellArg model}
      ${builtins.readFile ./bin/git-prepare-commit-msg-codex}
    '';
  };
in {
  config = lib.mkIf (cfg.enable && !cfg.server && cfg.commitMessageTool == "codex") {
    home.packages = [pkgs.codex];
    programs.git.hooks.prepare-commit-msg = "${codexPrepareCommitMessage}/bin/codex-prepare-commit-msg";
  };
}
