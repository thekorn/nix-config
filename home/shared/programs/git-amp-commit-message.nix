{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.custom.git;
  ampPrepareCommitMessage = pkgs.writeShellApplication {
    name = "amp-prepare-commit-msg";
    runtimeInputs = [
      pkgs.coreutils
      pkgs.git
      pkgs.llm-agents.amp
    ];
    text = builtins.readFile ./bin/git-prepare-commit-msg-amp;
  };
in {
  config = lib.mkIf (cfg.commitMessageTool == "amp") {
    home.packages = [pkgs.llm-agents.amp];
    programs.git.hooks.prepare-commit-msg = "${ampPrepareCommitMessage}/bin/amp-prepare-commit-msg";
  };
}
