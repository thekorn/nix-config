{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.custom.git;
  cursorPrepareCommitMessage = pkgs.writeShellApplication {
    name = "cursor-prepare-commit-msg";
    runtimeInputs = [
      pkgs.coreutils
      pkgs.git
      pkgs.llm-agents.cursor-agent
    ];
    text = builtins.readFile ./bin/git-prepare-commit-msg-cursor;
  };
in {
  config = lib.mkIf (cfg.commitMessageTool == "cursor") {
    home.packages = [pkgs.llm-agents.cursor-agent];
    programs.git.hooks.prepare-commit-msg = "${cursorPrepareCommitMessage}/bin/cursor-prepare-commit-msg";
  };
}
